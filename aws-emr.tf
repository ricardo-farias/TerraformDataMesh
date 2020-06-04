//resource "aws_iam_service_linked_role" "elasticbeanstalk" {
//  aws_service_name = "elasticmapreduce.amazonaws.com"
//}
//
//resource "aws_iam_role_policy" "emr-role-policy" {
//  name = "emr-role-policy"
//  policy = <<EOF
//{
//  "Version": "2020-06-04",
//  "Statement": [
//    {
//      "Action": [
//        "ec2:AuthorizeSecurityGroupEgress",
//                "ec2:AuthorizeSecurityGroupIngress",
//                "ec2:CancelSpotInstanceRequests",
//                "ec2:CreateNetworkInterface",
//                "ec2:CreateSecurityGroup",
//                "ec2:CreateTags",
//                "ec2:DeleteNetworkInterface",
//                "ec2:DeleteSecurityGroup",
//                "ec2:DeleteTags",
//                "ec2:DescribeAvailabilityZones",
//                "ec2:DescribeAccountAttributes",
//                "ec2:DescribeDhcpOptions",
//                "ec2:DescribeImages",
//                "ec2:DescribeInstanceStatus",
//                "ec2:DescribeInstances",
//                "ec2:DescribeKeyPairs",
//                "ec2:DescribeNetworkAcls",
//                "ec2:DescribeNetworkInterfaces",
//                "ec2:DescribePrefixLists",
//                "ec2:DescribeRouteTables",
//                "ec2:DescribeSecurityGroups",
//                "ec2:DescribeSpotInstanceRequests",
//                "ec2:DescribeSpotPriceHistory",
//                "ec2:DescribeSubnets",
//                "ec2:DescribeTags",
//                "ec2:DescribeVpcAttribute",
//                "ec2:DescribeVpcEndpoints",
//                "ec2:DescribeVpcEndpointServices",
//                "ec2:DescribeVpcs",
//                "ec2:DetachNetworkInterface",
//                "ec2:ModifyImageAttribute",
//                "ec2:ModifyInstanceAttribute",
//                "ec2:RequestSpotInstances",
//                "ec2:RevokeSecurityGroupEgress",
//                "ec2:RunInstances",
//                "ec2:TerminateInstances",
//                "ec2:DeleteVolume",
//                "ec2:DescribeVolumeStatus",
//                "ec2:DescribeVolumes",
//                "ec2:DetachVolume",
//                "iam:GetRole",
//                "iam:GetRolePolicy",
//                "iam:ListInstanceProfiles",
//                "iam:ListRolePolicies",
//                "iam:PassRole",
//                "s3:CreateBucket",
//                "s3:Get*",
//                "s3:List*",
//                "sdb:BatchPutAttributes",
//                "sdb:Select",
//                "sqs:CreateQueue",
//                "sqs:Delete*",
//                "sqs:GetQueue*",
//                "sqs:PurgeQueue",
//                "sqs:ReceiveMessage",
//                "cloudwatch:PutMetricAlarm",
//                "cloudwatch:DescribeAlarms",
//                "cloudwatch:DeleteAlarms",
//                "application-autoscaling:RegisterScalableTarget",
//                "application-autoscaling:DeregisterScalableTarget",
//                "application-autoscaling:PutScalingPolicy",
//                "application-autoscaling:DeleteScalingPolicy",
//                "application-autoscaling:Describe*"
//      ],
//      "Effect": "Allow",
//      "Resource": "*"
//    }
//  ]
//}
//EOF
//  role = aws_iam_role.emr-role.id
//}
//
//resource "aws_iam_instance_profile" "emr-instance-profile" {
//  name = "test_profile"
//  role = "${aws_iam_role.emr-role.name}"
//}
//
//resource "aws_emr_cluster" "cluster" {
//  name          = "data-mesh-cluster"
//  release_label = "emr-5.30.0"
//  applications  = ["Spark"]
//
//  termination_protection            = false
//  keep_job_flow_alive_when_no_steps = true
//
//  ec2_attributes {
//    //subnet_id                         = "${aws_subnet.main.id}"
//    //emr_managed_master_security_group = "${aws_security_group.sg.id}"
//    //emr_managed_slave_security_group  = "${aws_security_group.sg.id}"
//    instance_profile                  = "${aws_iam_instance_profile.emr_profile.arn}"
//  }
//
//  master_instance_group {
//    instance_type = "m5.xlarge"
//  }
//
//  core_instance_group {
//    instance_type  = "m5.xlarge"
//    instance_count = 1
//
//    ebs_config {
//      size                 = "40"
//      type                 = "gp2"
//      volumes_per_instance = 1
//    }
//  }
//
//  ebs_root_volume_size = 100
//
//  tags = {
//    env  = "env"
//  }
//
//  configurations_json = <<EOF
//  [
//    {
//      "Classification": "hadoop-env",
//      "Configurations": [
//        {
//          "Classification": "export",
//          "Properties": {
//            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
//          }
//        }
//      ],
//      "Properties": {}
//    },
//    {
//      "Classification": "spark-env",
//      "Configurations": [
//        {
//          "Classification": "export",
//          "Properties": {
//            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
//          }
//        }
//      ],
//      "Properties": {}
//    }
//  ]
//EOF
//
//  service_role = "${aws_iam_role.emr-role.arn}"
//}
//
//output "success" {
//  value = aws_emr_cluster.cluster.arn
//}