output "covid-data-bucket" {
  value = aws_s3_bucket.covid-data-bucket.bucket
}

output "bike-bucket" {
  value = aws_s3_bucket.bike-bucket.bucket
}

output "covid-data-bucket_arn" {
  value = aws_s3_bucket.covid-data-bucket.arn
}

output "bike-bucket_arn" {
  value = aws_s3_bucket.bike-bucket.arn
}

output "logging-bucket" {
  value = aws_s3_bucket.logging-bucket.bucket
}

output "athena-bucket" {
  value = aws_s3_bucket.athena-bucket.bucket
}
