resource "aws_ecr_repository" "airflow-dags" {
  name                 = "${var.project_name}-airflow-dag-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Terraform   = "true"
    Project     = var.project_name
    Environment = var.environment
  } 
}

resource "aws_ecr_repository" "airflow-base" {
  name                 = "${var.project_name}-airflow-base-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Terraform   = "true"
    Project     = var.project_name
    Environment = var.environment
  }
}