resource "aws_db_subnet_group" "airflow_subnet_group" {
  name       = "${var.project_name}-${var.environment}_airflow_private_subnet_group"
  subnet_ids = var.private_subnets
  tags = {
    Terraform = "true"
    Project = var.project_name
    Environment = var.environment
  }
}

resource "aws_db_instance" "airflow" {
  name                   = var.db_name
  identifier             = "${var.project_name}-${var.environment}-${var.identifier}"
  username               = var.username
  password               = var.password
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = var.db_engine
  engine_version         = var.engine_version
  instance_class         = var.instance_type  
  skip_final_snapshot    = true
  publicly_accessible    = var.accessible
  db_subnet_group_name   = aws_db_subnet_group.airflow_subnet_group.id
  depends_on             = [var.private_subnets]
  vpc_security_group_ids = aws_security_group.rds_security_group
  tags = {
    Terraform = "true"
    Project = var.project_name
    Environment = var.environment
  }
}

resource "aws_security_group" "rds_security_group" {
  name = "rds-security-group"

  description = "SG for RDS postgres servers"
  vpc_id = var.vpc_id

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
