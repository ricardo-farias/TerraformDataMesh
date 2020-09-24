locals {
  folder_list = [var.canonical_folder_name, var.raw_folder_name, var.error_folder_name]
}

resource "aws_s3_bucket" "covid-data-bucket" {
   bucket = "${var.project_name}-${var.environment}-${var.covid_data_bucket_name}"
   force_destroy = false
   tags = {
    Terraform = "true"
    Project = var.project_name
    Environment = var.environment
   }
 }

resource "aws_s3_bucket_object" "covid-data-folder" {
  bucket = "${var.project_name}-${var.environment}-${var.covid_data_bucket_name}"
  count = length(local.folder_list)
  key = local.folder_list [count.index]
  depends_on = [aws_s3_bucket.covid-data-bucket]
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

resource "aws_s3_bucket_object" "bike-data-folder" {
  bucket = "${var.project_name}-${var.environment}-${var.citi_bike_data_bucket_name}"
  count = length(local.folder_list)
  key = local.folder_list [count.index]
  depends_on = [aws_s3_bucket.bike-bucket]
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
