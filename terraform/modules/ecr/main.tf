######################
# Platform Shared Repo
######################

resource "aws_ecr_repository" "platform-shared" {
  name                 = "${var.project_name}-platform-shared-${var.environment}"
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

####################
# Covid Product Repo
####################
resource "aws_ecr_repository" "covid" {
  name                 = "${var.project_name}-covid-${var.environment}"
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

########################
# Citi-bike Product Repo
########################
resource "aws_ecr_repository" "citi-bike" {
  name                 = "${var.project_name}-citi-bike-${var.environment}"
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