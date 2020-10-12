locals {
  bucket_config_data_yaml = yamldecode(file("./modules/s3/bucket-config.yaml"))

  source_domain_list = flatten([for source_domain in local.bucket_config_data_yaml.source_domain :

    [for product_name in source_domain.product :
      [for folder_name in source_domain.folder : {
          "${source_domain.bucket}-${product_name}-${folder_name}" = {
          bucket = source_domain.bucket
          key = "${product_name} ${folder_name}"
      }}]
    ]])

  source_domain_config_map = { for item in local.source_domain_list :
    keys(item)[0] => values(item)[0]
  }

  non_source_domain_bucket_list = flatten([for bucket_name in local.bucket_config_data_yaml.non_source_domain : {
      "bucket-${bucket_name.bucket}" = {
        bucket = bucket_name.bucket
      }}
    ])

  source_domain_bucket_list = flatten([for source_domain_bucket_name in local.bucket_config_data_yaml.source_domain : {
      "bucket-${source_domain_bucket_name.bucket}" = {
        bucket = source_domain_bucket_name.bucket
      }
    }])

  non_source_domain_bucket_list_map = { for item in local.non_source_domain_bucket_list :
    keys(item)[0] => values(item)[0]
  }

  source_domain_bucket_list_map = { for item in local.source_domain_bucket_list :
    keys(item)[0] => values(item)[0]
  }

  bucket_list_map = merge(local.non_source_domain_bucket_list_map, local.source_domain_bucket_list_map)
}

resource "aws_s3_bucket" "create_bucket" {
  for_each = local.bucket_list_map
    bucket = "${var.project_name}-${var.environment}-${each.value.bucket}"
    force_destroy = false
    tags = {
      Terraform = "true"
      Project = var.project_name
      Environment = var.environment
    }
}

resource "aws_s3_bucket_object" "create_folder" {
  for_each = local.source_domain_config_map
    bucket = "${var.project_name}-${var.environment}-${each.value.bucket}"
    key = each.value.key
    force_destroy = false

  depends_on = [aws_s3_bucket.create_bucket]
}
