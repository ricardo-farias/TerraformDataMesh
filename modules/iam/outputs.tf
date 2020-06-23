output "emr_ec2_instance_profile" {
  value = aws_iam_instance_profile.emr-instance-profile.name
}

output "emr_service_role" {
  value = aws_iam_role.iam_emr_service_role.name
}