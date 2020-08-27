resource "aws_s3_bucket" "create_bucket" {
  bucket = var.bucket_name
  acl = "private"
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_object" "folder" {
    bucket = var.bucket_name
    count = length(var.key_name)
    key = var.key_name[count.index]

    depends_on = [aws_s3_bucket.create_bucket]
}