resource "aws_ecs_task_definition" "ecs-webserver" {
  execution_role_arn = var.task_execution_arn
  task_role_arn = var.task_execution_arn
  family = "Webserver"
  network_mode = var.network_mode
  cpu = 512
  memory = 1024
  requires_compatibilities = var.requires_compatibilities
  container_definitions = <<EOF
[
  {
    "name": "Webserver",
    "image": "${var.image}:latest",
    "essential": true,
    "portMappings":
    [
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
}

resource "aws_ecs_service" "ecs-webserver-service" {
  name = "Airflow-Webserver"
  task_definition = aws_ecs_task_definition.ecs-webserver.arn
  cluster = var.cluster_id
  desired_count = 1
  launch_type = var.launch_type

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name = "Webserver"
    container_port = 8080
  }

  network_configuration {
    subnets = var.subnets
    security_groups = [var.webserver_security_group_id]
    assign_public_ip = true
  }

  depends_on = [var.load_balancer, var.elastic_cache]
}

resource "aws_ecs_task_definition" "ecs-scheduler" {
  execution_role_arn = var.task_execution_arn
  task_role_arn = var.task_execution_arn
  family = "Scheduler"
  network_mode = var.network_mode
  cpu = 512
  memory = 2048
  requires_compatibilities = var.requires_compatibilities
  container_definitions = <<EOF
[
  {
    "name": "Scheduler",
    "image": "${var.image}:latest",
    "essential": true,
    "portMappings": [],
    "command": [
        "scheduler"
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
          "awslogs-group": "/ecs/Scheduler",
          "awslogs-region": "us-east-2",
          "awslogs-stream-prefix": "ecs"
        }
    }
  }
]
EOF
}

resource "aws_ecs_service" "ecs-scheduler-service" {
  name = "Airflow-Scheduler"
  task_definition = aws_ecs_task_definition.ecs-scheduler.arn
  cluster = var.cluster_id
  desired_count = 1
  launch_type = var.launch_type

  network_configuration {
    subnets = var.subnets
    security_groups = [var.scheduler_security_group_id]
    assign_public_ip = true
  }

  depends_on = [var.elastic_cache]
}

resource "aws_ecs_task_definition" "ecs-worker" {
  execution_role_arn = var.task_execution_arn
  task_role_arn = var.task_execution_arn
  family = "Worker"
  network_mode = var.network_mode
  cpu = 1024
  memory = 3072
  requires_compatibilities = var.requires_compatibilities
  container_definitions = <<EOF
[
  {
    "name": "Worker",
    "image": "${var.image}:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8793,
        "hostPort": 8793
      }
    ],
    "command": [
        "worker"
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
          "awslogs-group": "/ecs/Worker",
          "awslogs-region": "us-east-2",
          "awslogs-stream-prefix": "ecs"
        }
    }
  }
]
EOF
}

resource "aws_ecs_service" "ecs-worker-service" {
  name = "Airflow-Worker"
  task_definition = aws_ecs_task_definition.ecs-worker.arn
  cluster = var.cluster_id
  desired_count = 1
  launch_type = var.launch_type

  network_configuration {
    subnets = var.subnets
    security_groups = [var.worker_security_group_id]
    assign_public_ip = true
  }

  depends_on = [var.elastic_cache]
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