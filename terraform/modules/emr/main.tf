resource "aws_emr_cluster" "data-mesh-cluster" {
  name          = var.name
  release_label = var.release_label
  applications  = var.applications


  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true



  ec2_attributes {
    subnet_id                         = var.subnet_id
    emr_managed_master_security_group = var.emr_master_security_group
    emr_managed_slave_security_group  = var.emr_slave_security_group
    instance_profile                  = var.emr_ec2_instance_profile
    key_name = var.key_name
  }

  master_instance_group {
    instance_type = var.master_instance_type
  }

  core_instance_group {
    instance_type  = var.core_instance_type
    instance_count = var.core_instance_count
  }

  ebs_root_volume_size = 10

  log_uri = "s3://${var.logging_bucket}"

  step {
    name              = "Copy credentials file from s3."
    action_on_failure = "CONTINUE"
    hadoop_jar_step {
      jar  = "command-runner.jar"
      args = ["aws", "s3", "cp", "s3://data-mesh-poc-ENVIRONMENT-emr-configuration-scripts/credentials", "/home/hadoop/.aws/"]
    }
  }
  step {
    name              = "Downloading spark app jar"
    action_on_failure = "CONTINUE"
    hadoop_jar_step {
      jar  = "command-runner.jar"
      args = ["aws", "s3", "cp", "s3://data-mesh-poc-ENVIRONMENT-emr-configuration-scripts/SparkPractice-assembly-0.1.jar", "/home/hadoop/"]
    }
  }
  step {
    name              = "Submit spark job to emr"
    action_on_failure = "CONTINUE"
    hadoop_jar_step {
      jar = "command-runner.jar"
      args = ["spark-submit", "--class", "com.ricardo.farias.App", "/home/hadoop/SparkPractice-assembly-0.1.jar"]
    }
  }

  service_role = var.emr_service_role
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
