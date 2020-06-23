output "glue_database_name" {
  value = aws_glue_catalog_database.aws_glue_catalog_database.name
}

output "glue_catalog_id" {
  value = aws_glue_catalog_database.aws_glue_catalog_database.catalog_id
}