resource "aws_iam_group" "covid-italy-team-group" {
  name = "covid-italy-team"
}

resource "aws_iam_group_policy" "covid-italy-group-policy" {
  group = aws_iam_group.covid-italy-team-group.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::${var.athena_bucket_name}",
                "arn:aws:s3:::${var.covid_data_bucket_name}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.athena_bucket_name}/*",
                "arn:aws:s3:::${var.covid_data_bucket_name}/covid-italy/*",
                "arn:aws:s3:::${var.covid_data_bucket_name}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "glue:*",
            "Resource": [
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:catalog",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:database/*",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid19_italy_province",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid19_italy_region",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/testdatafromjson",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/testdatafromcsv"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "athena:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "DenyItalyGlueTableAccess",
            "Effect": "Deny",
            "Action": [
                "athena:GetQueryExecution",
                "athena:GetQueryResults",
                "athena:StartQueryExecution",
                "athena:StopQueryExecution"
            ],
            "Resource": [
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid_us",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid_us_counties",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid_us_states"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_group" "covid-us-team-group" {
  name = "covid-us-team"
}

resource "aws_iam_group_policy" "covid-us-group-policy" {
  group = aws_iam_group.covid-us-team-group.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::${var.athena_bucket_name}",
                "arn:aws:s3:::${var.covid_data_bucket_name}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.athena_bucket_name}/*",
                "arn:aws:s3:::${var.covid_data_bucket_name}/covid-us/*",
                "arn:aws:s3:::${var.covid_data_bucket_name}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "glue:*",
            "Resource": [
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:catalog",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:database/*",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid_us",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid_us_counties",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid_us_states",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/testdatafromjson",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/testdatafromcsv"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "athena:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "DenyItalyGlueTableAccess",
            "Effect": "Deny",
            "Action": [
                "athena:GetQueryExecution",
                "athena:GetQueryResults",
                "athena:StartQueryExecution",
                "athena:StopQueryExecution"
            ],
            "Resource": [
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid19_italy_province",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid19_italy_region"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_group" "citi-bike-team-group" {
  name = "citi-bike-team"
}

resource "aws_iam_group_policy" "citi-bike-group-policy" {
  group = aws_iam_group.citi-bike-team-group.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::${var.athena_bucket_name}",
                "arn:aws:s3:::${var.citi_bike_bucket_name}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.athena_bucket_name}/*",
                "arn:aws:s3:::${var.citi_bike_bucket_name}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "glue:*",
            "Resource": [
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:catalog",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:database/*",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/citibiketripdata201306"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "athena:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "DenyItalyGlueTableAccess",
            "Effect": "Deny",
            "Action": [
                "athena:GetQueryExecution",
                "athena:GetQueryResults",
                "athena:StartQueryExecution",
                "athena:StopQueryExecution"
            ],
            "Resource": [
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid19_italy_province",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid19_italy_region",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid_us",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid_us_counties",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/covid_us_states",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/testdatafromjson",
                "arn:aws:glue:us-east-2:${var.glue_catalog_id}:table/${var.glue_catalog_name}/testdatafromcsv"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user" "covid-us-team-member-user" {
  name = "covid-us-member1"
}

resource "aws_iam_user" "covid-italy-team-member-user" {
  name = "covid-italy-member1"
}

resource "aws_iam_user" "citi-bike-team-member-user" {
  name = "citi-bike-member1"
}

resource "aws_iam_user_group_membership" "covid-team-assignment" {
  user = aws_iam_user.covid-us-team-member-user.name
  groups = [ aws_iam_group.covid-us-team-group.name]
}

resource "aws_iam_user_group_membership" "covid-italy-team-assignment" {
  user   = aws_iam_user.covid-italy-team-member-user.name
  groups = [aws_iam_group.covid-italy-team-group.name]
}

resource "aws_iam_user_group_membership" "citi-bike-team-assignment" {
  user = aws_iam_user.citi-bike-team-member-user.name
  groups = [aws_iam_group.citi-bike-team-group.name]
}
