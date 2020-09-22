resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = "${var.project_name}-${var.environment}-${var.database_name}"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

resource "null_resource" "lakeFormation" {
  depends_on = [aws_glue_catalog_database.aws_glue_catalog_database]

  provisioner "local-exec" {
    command = "python3 ../lakeFormation/LakeFormationController.py $PARAMS"
    environment = {
      PARAMS = jsonencode(
        {
          db_name = aws_glue_catalog_database.aws_glue_catalog_database.name,
          account_id = data.aws_caller_identity.current.account_id,
          lf_admin = var.lake_formation_admin_arn,
          emr_instance_profile = var.iam_emr_instance_profile_role_arn,
          s3_domain_locations = [
            "${var.covid_domain_location_arn}/covid-italy",
            "${var.covid_domain_location_arn}/covid-us",
            var.bike_domain_location_arn
          ]
        }
      )
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'LF getting destroyed'"
  }
}