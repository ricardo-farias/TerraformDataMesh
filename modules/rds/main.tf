
resource "aws_db_subnet_group" "airflow_subnet_group" {
  name = "${var.db_name}-subnet-group"
  subnet_ids = var.subnets
}



resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = var.db_engine
  engine_version       = var.engine_version
  instance_class       = var.instance_type
  name                 = var.db_name
  identifier = var.identifier
  username             = var.db_username
  password = var.password
  publicly_accessible = var.accessible
  availability_zone = "us-east-2a"
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name = aws_db_subnet_group.airflow_subnet_group.id
  depends_on = [var.security_group_ids, var.subnets]
}