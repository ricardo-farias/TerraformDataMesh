// EMR Security rules
// TODO: Add Security Group Display Name
resource "aws_security_group_rule" "tcp-master-connection-to-slave" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id = aws_security_group.emr-security-group-slave.id
  security_group_id = aws_security_group.emr-security-group-master.id
}

resource "aws_security_group_rule" "tcp-slave-connection-to-master" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id = aws_security_group.emr-security-group-master.id
  security_group_id = aws_security_group.emr-security-group-slave.id
}
resource "aws_security_group_rule" "udp-master-connection-to-slave" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "udp"
  source_security_group_id = aws_security_group.emr-security-group-slave.id
  security_group_id = aws_security_group.emr-security-group-master.id
}
resource "aws_security_group_rule" "udp-slave-connection-to-master" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "udp"
  source_security_group_id = aws_security_group.emr-security-group-master.id
  security_group_id = aws_security_group.emr-security-group-slave.id
}

// EMR Security group Master
resource "aws_security_group" "emr-security-group-master" {
  name        = "security-group-master"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    to_port = 22
    from_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8998
    protocol = "tcp"
    security_groups = [aws_security_group.worker_security_group.id]
    to_port = 8998
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_subnet.public-subnet-1]
}

// EMR Security group Slave
resource "aws_security_group" "emr-security-group-slave" {
  name        = "security-group-slave"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_subnet.public-subnet-1]
}

// Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

// Route Tables
resource "aws_route_table" "r" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.r.id
}

//----------------ECS Network/Security Groups------------------ UNDER CONSTRUCTION


resource "aws_security_group" "rds_security_group" {
  name = "rds-security_group"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 5432
    protocol = "tcp"
    to_port = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
