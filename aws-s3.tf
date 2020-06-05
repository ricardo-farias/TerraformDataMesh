resource "aws_s3_bucket" "covid-us-bucket" {
  bucket = "data-mesh-covid-us-domain"
  acl    = "private"
  tags = {
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "covid-italy-bucket" {
  bucket = "data-mesh-covid-italy-domain"
  acl  = "private"
  tags = {
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "covid-us-bucket-policy" {
  bucket = aws_s3_bucket.covid-us-bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "COVIDBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "AllowCovidTeamMember",
      "Effect": "Allow",
      "Principal": { "AWS" : "${aws_iam_user.covid-us-team-member-user.arn}" },
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.covid-us-bucket.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "covid-italy-bucket-policy" {
  bucket = aws_s3_bucket.covid-italy-bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "COVIDBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "AllowCovidTeamMember",
      "Effect": "Allow",
      "Principal": { "AWS" : "${aws_iam_user.covid-italy-team-member-user.arn}" },
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.covid-italy-bucket.arn}/*"
    }
  ]
}
POLICY
}