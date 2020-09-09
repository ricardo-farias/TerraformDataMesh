resource "aws_s3_bucket" "create_bucket"{
  bucket = var.bucket_name
  acl = "private"

  force_destroy = var.force_destroy
}

# module "covid-data-bucket" {
#   source = "./modules/s3"
#   bucket_name = var.covid_data_bucket_name
#   force_destroy = false
# }

# module "bike-bucket" {
#   source = "./modules/s3"
#   bucket_name = var.citi_bike_data_bucket_name
#   force_destroy = false
# }

# module "logging-bucket" {
#   source = "./modules/s3"
#   bucket_name = var.logging_bucket_name
#   force_destroy = true
# }

# module "athena-bucket" {
#   source = "./modules/s3"
#   bucket_name = var.athena_bucket_name
#   force_destroy = true
# }