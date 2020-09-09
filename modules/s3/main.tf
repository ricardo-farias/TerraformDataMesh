
resource "aws_s3_bucket" "covid-data-bucket" {
   bucket = "${var.project_name}-${var.environment}-${var.covid_data_bucket_name}"
   force_destroy = false
   tags = {
    Terraform = "true"
    Project = var.project_name
    Environment = var.environment
   }
 }

 resource "aws_s3_bucket" "bike-bucket" {
   bucket = "${var.project_name}-${var.environment}-${var.citi_bike_data_bucket_name}"
   force_destroy = false
   tags = {
     Terraform = "true"
     Project = var.project_name
     Environment = var.environment
   }
 }

 resource "aws_s3_bucket" "logging-bucket" {
   bucket = "${var.project_name}-${var.environment}-${var.logging_bucket_name}"
   force_destroy = true
   tags = {
     Terraform = "true"
     Project = var.project_name
     Environment = var.environment
   }
 }

 resource "aws_s3_bucket" "athena-bucket" {
   bucket = "${var.project_name}-${var.environment}-${var.athena_bucket_name}"
   force_destroy = true
   tags = {
     Terraform = "true"
     Project = var.project_name
     Environment = var.environment
   }
}
