resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = replace("${var.project_name}-${var.environment}-${var.database_name}", "-", "_")
}
