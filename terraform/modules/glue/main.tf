resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = "${var.project_name}_${var.environment}_${var.database_name}"
}