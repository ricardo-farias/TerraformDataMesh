output "rds_address" {
  value = aws_db_instance.default.address
}

output "rds_name" {
  value = aws_db_instance.default.name
}

output "engine" {
  value = aws_db_instance.default.engine
}

output "rds_port" {
  value = aws_db_instance.default.port
}

output "rds_username" {
  value = aws_db_instance.default.username
}