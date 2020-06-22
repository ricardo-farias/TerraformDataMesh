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
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.athena-data-mesh-output-bucket.bucket}/*",
                "arn:aws:s3:::${aws_s3_bucket.covid-bucket.bucket}/covid-italy/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "glue:CreateDatabase",
                "glue:DeleteDatabase",
                "glue:GetDatabase",
                "glue:GetDatabases",
                "glue:UpdateDatabase",
                "glue:CreateTable",
                "glue:DeleteTable",
                "glue:BatchDeleteTable",
                "glue:UpdateTable",
                "glue:GetTable",
                "glue:GetTables",
                "glue:BatchCreatePartition",
                "glue:CreatePartition",
                "glue:DeletePartition",
                "glue:BatchDeletePartition",
                "glue:UpdatePartition",
                "glue:GetPartition",
                "glue:GetPartitions",
                "glue:BatchGetPartition"
            ],
            "Resource": [
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:catalog",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:database/*",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/covid19_italy_province",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/covid19_italy_region",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/testdatafromjson",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/testdatafromcsv"
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
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/covid_us",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/covid_us_countries",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/covid_us_states"
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
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.athena-data-mesh-output-bucket.bucket}/*",
                "arn:aws:s3:::${aws_s3_bucket.covid-bucket.bucket}/covid-us/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation",
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "glue:CreateDatabase",
                "glue:DeleteDatabase",
                "glue:GetDatabase",
                "glue:GetDatabases",
                "glue:UpdateDatabase",
                "glue:CreateTable",
                "glue:DeleteTable",
                "glue:BatchDeleteTable",
                "glue:UpdateTable",
                "glue:GetTable",
                "glue:GetTables",
                "glue:BatchCreatePartition",
                "glue:CreatePartition",
                "glue:DeletePartition",
                "glue:BatchDeletePartition",
                "glue:UpdatePartition",
                "glue:GetPartition",
                "glue:GetPartitions",
                "glue:BatchGetPartition"
            ],
            "Resource": [
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:catalog",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:database/*",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/covid_us",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/covid_us_countries",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/covid_us_states",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/testdatafromjson",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/testdatafromcsv"
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
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/covid19_italy_province",
                "arn:aws:glue:us-east-2:${aws_glue_catalog_database.aws_glue_catalog_database.catalog_id}:table/${aws_glue_catalog_database.aws_glue_catalog_database.name}/covid19_italy_region"
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

resource "aws_iam_user_group_membership" "covid-team-assignment" {
  user = aws_iam_user.covid-us-team-member-user.name
  groups = [ aws_iam_group.covid-us-team-group.name]
}

resource "aws_iam_user_group_membership" "covid-italy-team-assignment" {
  user   = aws_iam_user.covid-italy-team-member-user.name
  groups = [aws_iam_group.covid-italy-team-group.name]
}

//------------------ emr iam role
resource "aws_iam_role" "iam_emr_service_role" {
  name = "iam_emr_service_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticmapreduce.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_emr_service_policy" {
  name = "iam_emr_service_policy"
  role = aws_iam_role.iam_emr_service_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
            "ec2:AuthorizeSecurityGroupEgress", "ec2:AuthorizeSecurityGroupIngress", "ec2:CancelSpotInstanceRequests",
            "ec2:CreateNetworkInterface", "ec2:CreateSecurityGroup", "ec2:CreateTags", "ec2:DeleteNetworkInterface",
            "ec2:DeleteSecurityGroup", "ec2:DeleteTags", "ec2:DescribeAvailabilityZones",
            "ec2:DescribeAccountAttributes", "ec2:DescribeDhcpOptions", "ec2:DescribeInstanceStatus",
            "ec2:DescribeInstances", "ec2:DescribeKeyPairs", "ec2:DescribeNetworkAcls", "ec2:DescribeNetworkInterfaces",
            "ec2:DescribePrefixLists", "ec2:DescribeRouteTables", "ec2:DescribeSecurityGroups",
            "ec2:DescribeSpotInstanceRequests", "ec2:DescribeSpotPriceHistory", "ec2:DescribeSubnets",
            "ec2:DescribeVpcAttribute", "ec2:DescribeVpcEndpoints", "ec2:DescribeVpcEndpointServices",
            "ec2:DescribeVpcs", "ec2:DetachNetworkInterface", "ec2:ModifyImageAttribute", "ec2:ModifyInstanceAttribute",
            "ec2:RequestSpotInstances", "ec2:RevokeSecurityGroupEgress", "ec2:RunInstances", "ec2:TerminateInstances",
            "ec2:DeleteVolume", "ec2:DescribeVolumeStatus", "ec2:DescribeVolumes", "ec2:DetachVolume", "iam:GetRole",
            "iam:GetRolePolicy", "iam:ListInstanceProfiles", "iam:ListRolePolicies", "iam:PassRole", "s3:CreateBucket",
            "s3:Get*", "s3:List*", "sdb:BatchPutAttributes", "sdb:Select", "sqs:CreateQueue", "sqs:Delete*",
            "sqs:GetQueue*", "sqs:PurgeQueue", "sqs:ReceiveMessage"
        ]
    }]
}
EOF
}

//------------------------- emr instance role

resource "aws_iam_role" "iam-emr-instance-profile-role" {
  name = "iam-emr-instance-profile-role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "emr-instance-profile" {
  name  = "emr-instance-profile"
  role = aws_iam_role.iam-emr-instance-profile-role.name
}

resource "aws_iam_role_policy" "iam_emr_instance-profile_policy" {
  name = "iam-emr-instance-profile_policy"
  role = aws_iam_role.iam-emr-instance-profile-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
            "cloudwatch:*", "dynamodb:*", "ec2:Describe*", "elasticmapreduce:Describe*",
            "elasticmapreduce:ListBootstrapActions", "elasticmapreduce:ListClusters",
            "elasticmapreduce:ListInstanceGroups", "elasticmapreduce:ListInstances",
            "elasticmapreduce:ListSteps", "kinesis:CreateStream", "kinesis:DeleteStream", "kinesis:DescribeStream",
            "kinesis:GetRecords", "kinesis:GetShardIterator", "kinesis:MergeShards", "kinesis:PutRecord",
            "kinesis:SplitShard", "rds:Describe*", "s3:*", "sdb:*", "sns:*", "sqs:*", "glue:CreateDatabase",
            "glue:UpdateDatabase", "glue:DeleteDatabase", "glue:GetDatabase", "glue:GetDatabases",
            "glue:CreateTable", "glue:UpdateTable", "glue:DeleteTable", "glue:GetTable", "glue:GetTables",
            "glue:GetTableVersions", "glue:CreatePartition", "glue:BatchCreatePartition", "glue:UpdatePartition",
            "glue:DeletePartition", "glue:BatchDeletePartition", "glue:GetPartition", "glue:GetPartitions",
            "glue:BatchGetPartition", "glue:CreateUserDefinedFunction", "glue:UpdateUserDefinedFunction",
            "glue:DeleteUserDefinedFunction", "glue:GetUserDefinedFunction", "glue:GetUserDefinedFunctions"
        ]
    }]
}
EOF
}


output "output" {
  value = [
    aws_emr_cluster.data-mesh-cluster.id
  ]
}

