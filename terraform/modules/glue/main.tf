resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = "${var.project_name}${var.environment}${var.database_name}"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

resource "null_resource" "lakeFormation" {
  depends_on = [aws_glue_catalog_database.aws_glue_catalog_database]

  triggers = {
    db_name_tf = aws_glue_catalog_database.aws_glue_catalog_database.name,
    account_id_tf = data.aws_caller_identity.current.account_id,
    lf_admin_tf = var.lake_formation_admin,
    project_environment_tf = "${var.project_name}-${var.environment}",
    covid_location = var.covid_domain_location_arn,
    bike_location = var.bike_domain_location_arn
  }

  provisioner "local-exec" {
    command = "python3 ../lakeFormation/LakeFormationController.py create $PARAMS"
    environment = {
      PARAMS = jsonencode(
        {
          db_name = aws_glue_catalog_database.aws_glue_catalog_database.name,
          account_id = data.aws_caller_identity.current.account_id,
          lf_admin = var.lake_formation_admin,
          s3_domain_locations = [
            "${var.project_name}-${var.environment}-${var.covid_domain_location_arn}/covid-italy",
            "${var.project_name}-${var.environment}-${var.covid_domain_location_arn}/covid-us",
            "${var.project_name}-${var.environment}-${var.bike_domain_location_arn}"
          ]
        }
      )
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "python3 ../lakeFormation/LakeFormationController.py destroy $PARAMS"
    environment = {
      PARAMS = jsonencode(
      {
        db_name = self.triggers.db_name_tf,
        account_id = self.triggers.account_id_tf,
        lf_admin = self.triggers.lf_admin_tf,
        s3_domain_locations = [
          "${self.triggers.project_environment_tf}-${self.triggers.covid_location}/covid-italy",
          "${self.triggers.project_environment_tf}-${self.triggers.covid_location}/covid-us",
          "${self.triggers.project_environment_tf}-${self.triggers.bike_location}"
        ]
      }
      )
    }
  }
}