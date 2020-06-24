resource "aws_s3_bucket" "create_bucket"{
  bucket = var.bucket_name
  acl = "private"

  force_destroy = var.force_destroy
}