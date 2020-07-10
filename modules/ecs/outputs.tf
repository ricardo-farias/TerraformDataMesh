output "ecs_task_arn" {
  value = aws_ecs_task_definition.ecs-task.arn
}

output "ecs_task_family" {
  value = aws_ecs_task_definition.ecs-task.family
}

output "ecs_task_revision" {
  value = aws_ecs_task_definition.ecs-task.revision
}

output "ecs_service_id" {
  value = aws_ecs_service.ecs-service.id
}

output "ecs_service_iam_role" {
  value = aws_ecs_service.ecs-service.iam_role
}

output "ecs_service_cluster" {
  value = aws_ecs_service.ecs-service.cluster
}