resource "aws_ecs_cluster" "airflow" {
  name = "airflow"
}

resource "aws_ecs_task_definition" "ecs-task" {
  container_definitions = <<TASK_DEFINITION
[
    {
      "dnsSearchDomains": null,
      "environmentFiles": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/${var.family_name}",
          "awslogs-region": "us-east-2",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "entryPoint": [],
      "portMappings": [
        {
          "hostPort": ${var.hostPort},
          "protocol": "tcp",
          "containerPort": ${var.hostPort}
        }
      ],
      "command": [
        ${var.command}
      ],
      "linuxParameters": null,
      "cpu": 0,
      "environment": [
        {
          "name": "AIRFLOW__CORE__FERNET_KEY",
          "value": ${var.fernet_key}
        },
        {
          "name": "REDIS_HOST",
          "value": ${var.redis_host}
        }
      ],
      "resourceRequirements": null,
      "ulimits": null,
      "dnsServers": null,
      "mountPoints": [],
      "workingDirectory": null,
      "secrets": [
        {
          "valueFrom": "dbInstanceIdentifier",
          "name": "POSTGRES_DB"
        },
        {
          "valueFrom": "host",
          "name": "POSTGRES_HOST"
        },
        {
          "valueFrom": "password",
          "name": "POSTGRES_PASSWORD"
        },
        {
          "valueFrom": "port",
          "name": "POSTGRES_PORT"
        },
        {
          "valueFrom": "username",
          "name": "POSTGRES_USER"
        }
      ],
      "dockerSecurityOptions": null,
      "memory": null,
      "memoryReservation": null,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": ${var.image},
      "startTimeout": null,
      "firelensConfiguration": null,
      "dependsOn": null,
      "disableNetworking": null,
      "interactive": null,
      "healthCheck": null,
      "essential": true,
      "links": null,
      "hostname": null,
      "extraHosts": null,
      "pseudoTerminal": null,
      "user": null,
      "readonlyRootFilesystem": null,
      "dockerLabels": null,
      "systemControls": null,
      "privileged": null,
      "name": ${var.family_name}
    }
  ]
TASK_DEFINITION
  execution_role_arn = var.task_execution_arn
  task_role_arn = var.task_execution_arn
  family = var.family_name
  network_mode = var.network_mode
  cpu = var.cpu
  memory = var.memory
  requires_compatibilities = var.requires_compatibilities
}