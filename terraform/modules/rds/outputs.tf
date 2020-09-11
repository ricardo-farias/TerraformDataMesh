output "rds_address" {
  value = aws_db_instance.airflow.address
}

output "rds_name" {
  value = aws_db_instance.airflow.name
}

output "engine" {
  value = aws_db_instance.airflow.engine
}

output "rds_port" {
  value = aws_db_instance.airflow.port
}

output "rds_username" {
  value = aws_db_instance.airflow.username
}