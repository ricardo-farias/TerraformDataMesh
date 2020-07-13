//resource "aws_ecs_task_definition" "ecs-redis" {
//  container_definitions = <<TASK_DEFINITION
//[
//    {
//      "dnsSearchDomains": null,
//      "environmentFiles": null,
//      "logConfiguration": {
//        "logDriver": "awslogs",
//        "secretOptions": null,
//        "options": {
//          "awslogs-group": "/ecs/Redis",
//          "awslogs-region": "us-east-2",
//          "awslogs-stream-prefix": "ecs"
//        }
//      },
//      "entryPoint": [],
//      "portMappings": [
//        {
//          "hostPort": 6379,
//          "protocol": "tcp",
//          "containerPort": 6379
//        }
//      ],
//      "command": [],
//      "linuxParameters": null,
//      "cpu": 0,
//      "environment": [
//        {
//          "name": "AIRFLOW__CORE__FERNET_KEY",
//          "value": ${var.fernet_key}
//        },
//        {
//          "name": "REDIS_HOST",
//          "value": ${var.redis_host}
//        }
//      ],
//      "resourceRequirements": null,
//      "ulimits": null,
//      "dnsServers": null,
//      "mountPoints": [],
//      "workingDirectory": null,
//      "secrets": [
//        {
//          "valueFrom": "dbInstanceIdentifier",
//          "name": "POSTGRES_DB"
//        },
//        {
//          "valueFrom": "host",
//          "name": "POSTGRES_HOST"
//        },
//        {
//          "valueFrom": "password",
//          "name": "POSTGRES_PASSWORD"
//        },
//        {
//          "valueFrom": "port",
//          "name": "POSTGRES_PORT"
//        },
//        {
//          "valueFrom": "username",
//          "name": "POSTGRES_USER"
//        }
//      ],
//      "dockerSecurityOptions": null,
//      "memory": null,
//      "memoryReservation": null,
//      "volumesFrom": [],
//      "stopTimeout": null,
//      "image": "docker.io/redis:5.0.5",
//      "startTimeout": null,
//      "firelensConfiguration": null,
//      "dependsOn": null,
//      "disableNetworking": null,
//      "interactive": null,
//      "healthCheck": null,
//      "essential": true,
//      "links": null,
//      "hostname": null,
//      "extraHosts": null,
//      "pseudoTerminal": null,
//      "user": null,
//      "readonlyRootFilesystem": null,
//      "dockerLabels": null,
//      "systemControls": null,
//      "privileged": null,
//      "name": Redis
//    }
//  ]
//TASK_DEFINITION
//  execution_role_arn = var.task_execution_arn
//  task_role_arn = var.task_execution_arn
//  family = "Redis"
//  network_mode = var.network_mode
//  cpu = "1024"
//  memory = "2048"
//  requires_compatibilities = var.requires_compatibilities
//}
//
//resource "aws_ecs_service" "ecs-redis-service" {
//  name = Airflow-Redis
//  task_definition = aws_ecs_task_definition.ecs-redis
//  cluster = var.cluster_id
//  desired_count = 1
//  launch_type = var.launch_type
//
//  network_configuration {
//    subnets = [var.private_subnet]
//    security_groups = var.redis_security_group_id
//    assign_public_ip = true
//  }
//}


resource "aws_ecs_task_definition" "ecs-webserver" {
  container_definitions = <<EOF
[
  {
    "name": "Webserver",
    "image": "${var.image}":latest,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "command": [
        "webserver"
    ],
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
    "environment": [
      {
        "name": "REDIS_HOST",
        "value": "${var.redis_host}"
      },
      {
        "name": "REDIS_PORT",
        "value": "6379"
      },
      {
        "name": "FERNET_KEY",
        "value": "${var.fernet_key}"
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/Webserver",
          "awslogs-region": "us-east-2",
          "awslogs-stream-prefix": "ecs"
        }
    }
  }
]
EOF
  execution_role_arn = var.task_execution_arn
  task_role_arn = var.task_execution_arn
  family = "Webserver"
  network_mode = var.network_mode
  cpu = "1024"
  memory = "512"
  requires_compatibilities = var.requires_compatibilities
}

resource "aws_ecs_service" "ecs-webserver-service" {
  name = "Airflow-Webserver"
  task_definition = aws_ecs_task_definition.ecs-webserver
  cluster = var.cluster_id
  desired_count = 1
  launch_type = var.launch_type

  load_balancer {
    container_name = var.load_balancer_name
    container_port = 8080
  }

  network_configuration {
    subnets = [var.public_subnet, var.private_subnet]
    security_groups = [var.webserver_security_group_id]
    assign_public_ip = true
  }
}

