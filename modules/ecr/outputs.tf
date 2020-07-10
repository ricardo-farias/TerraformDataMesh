
output "airflow-ecr-repo-arn" {
  value = aws_ecr_repository.airflow-ecr-repo.arn
}

output "airflow-ecr-repo-id" {
  value = aws_ecr_repository.airflow-ecr-repo.id
}

output "airflow-ecr-repo-url" {
  value = aws_ecr_repository.airflow-ecr-repo.repository_url
}