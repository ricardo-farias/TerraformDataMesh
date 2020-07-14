resource "aws_vpc" "vpc" {
  cidr_block           = "172.0.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames  = "true"
  tags = {
    name = "vpc"
  }
}

// Public Subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.0.0.0/24"
  availability_zone = "us-east-2a"
  tags = {
    name = "public subnet"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.0.1.0/24"
  availability_zone = "us-east-2b"
  tags = {
    name = "public subnet"
  }
}

// Private Subnet
resource "aws_subnet" "private-subnet" {
  cidr_block = "172.0.2.0/24"
  vpc_id = aws_vpc.vpc.id
  availability_zone = "us-east-2c"
  tags = {
    name = "private subnet"
  }
}

// EMR Security rules
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
resource "aws_security_group" "load-balancer-security-group" {
  name        = "load-balancer-security-group"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    to_port = 8080
    from_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_subnet.public-subnet-1]
}

resource "aws_security_group" "webserver-security-group" {
  name        = "webserver-security-group"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    to_port = 8080
    from_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    to_port = 65535
    from_port = 0
    protocol = "tcp"
    security_groups = [aws_security_group.load-balancer-security-group.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_subnet.public-subnet-1]
}

resource "aws_security_group" "redis_security_group" {
  name        = "redis-security-group"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    to_port = 6379
    from_port = 6379
    protocol = "tcp"
    security_groups = [aws_security_group.scheduler_security_group.id, aws_security_group.worker_security_group.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_subnet.private-subnet]
}

resource "aws_security_group" "worker_security_group" {
  name        = "worker-security-group"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    to_port = 8793
    from_port = 8793
    protocol = "tcp"
    security_groups = [aws_security_group.webserver-security-group.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_subnet.private-subnet]
}

resource "aws_security_group" "scheduler_security_group" {
  name        = "scheduler-security-group"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_subnet.private-subnet]
}

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
