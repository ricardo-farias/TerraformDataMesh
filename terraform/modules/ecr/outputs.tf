 output "airflow-ecr-base-repo-url" {
   value = aws_ecr_repository.airflow-base.repository_url
 }

 output "airflow-base" {
   value = aws_ecr_repository.airflow-base.id
 }

output "airflow-ecr-dags-repo-url" {
   value = aws_ecr_repository.airflow-dags.repository_url
 }

 output "airflow-dags" {
   value = aws_ecr_repository.airflow-dags.id
 }