resource "aws_s3_bucket" "covid-bucket" {
  bucket = "data-mesh-covid-domain"
  acl    = "private"

  tags = {
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.covid-bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "COVIDBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "AllowCovidTeamMember",
      "Effect": "Allow",
      "Principal": { "AWS" : "${aws_iam_user.covid-team-member-user.arn}" },
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.covid-bucket.arn}/*"
    }
  ]
}
POLICY
}