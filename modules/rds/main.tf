resource "aws_db_subnet_group" "airflow_subnet_group" {
  name       = "airflow_private_subnet_group"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "airflow" {
  name                   = var.name
  identifier             = var.identifier
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
}

