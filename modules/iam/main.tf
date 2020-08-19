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
                "arn:aws:s3:::${var.citi-bike-bucket-name}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.athena_bucket_name}/*",
                "arn:aws:s3:::${var.citi-bike-bucket-name}/*"
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

//-----------------------ECS Task Execution Role
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs-task-execution-policy" {
  name = "ecs-task-execution-policy"
  role = aws_iam_role.ecsTaskExecutionRole.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ds:CreateComputer",
                "ds:DescribeDirectories",
                "ec2:DescribeInstanceStatus",
                "logs:*",
                "ssm:*",
                "ec2messages:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}