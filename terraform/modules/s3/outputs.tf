output "covid-data-bucket" {
  value = aws_s3_bucket.covid-data-bucket.bucket
}

output "bike-bucket" {
  value = aws_s3_bucket.bike-bucket.bucket
}

output "logging-bucket" {
  value = aws_s3_bucket.logging-bucket.bucket
}

output "athena-bucket" {
  value = aws_s3_bucket.athena-bucket.bucket
}
