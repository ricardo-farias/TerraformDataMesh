# output "emr_ec2_instance_profile" {
#   value = aws_iam_instance_profile.emr-instance-profile.name
# }

# output "emr_service_role" {
#   value = aws_iam_role.iam_emr_service_role.name
# }

# output "ec2_task_executor_arn" {
#   value = aws_iam_role.ecsTaskExecutionRole.arn
# }

# output "ecs_task_execution_arn" {
#   value = aws_iam_role.ecsTaskExecutionRole.arn
# }

output "iam_emr_instance_profile_role_arn" {
  value = aws_iam_role.iam-emr-instance-profile-role.arn
}