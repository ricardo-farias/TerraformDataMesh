// VPC

resource "aws_vpc" "emr-vpc" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true
}

// Subnet

resource "aws_subnet" "emr-subnet" {
  vpc_id     = aws_vpc.emr-vpc.id
  cidr_block = "172.31.0.0/16"

  tags = {
    name = "emr_test"
  }
}
// Security rules
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
resource "aws_security_group_rule" "master-allow-all-outbound-traffic" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.emr-security-group-master.id
}
resource "aws_security_group_rule" "slave-allow-all-outbound-traffic" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.emr-security-group-slave.id
}
resource "aws_security_group_rule" "ssh-into-master" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.emr-security-group-master.id
}

// Security group Master

resource "aws_security_group" "emr-security-group-master" {
  name        = "security-group-master"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.emr-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_subnet.emr-subnet]

  lifecycle {
    ignore_changes = [ingress, egress]
  }
}

// Security group Slave

resource "aws_security_group" "emr-security-group-slave" {
  name        = "security-group-slave"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.emr-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_subnet.emr-subnet]

  lifecycle {
    ignore_changes = [ingress, egress]
  }
}

// Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.emr-vpc.id
}

// Route Tables

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.emr-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.emr-vpc.id
  route_table_id = aws_route_table.r.id
}




resource "aws_emr_cluster" "data-mesh-cluster" {
  name          = "Data Mesh Cluster"
  release_label = "emr-5.30.0"
  applications  = ["Spark", "Zeppelin", "JupyterHub"]


  termination_protection            = false
  keep_job_flow_alive_when_no_steps = true



  ec2_attributes {
    subnet_id                         = aws_subnet.emr-subnet.id
    emr_managed_master_security_group = aws_security_group.emr-security-group-master.id
    emr_managed_slave_security_group  = aws_security_group.emr-security-group-slave.id
    instance_profile                  = aws_iam_instance_profile.emr-instance-profile.name
    key_name = "EMR-key-pair"
  }

  master_instance_group {
    instance_type = "m5.xlarge"
  }

  core_instance_group {
    instance_type  = "m5.xlarge"
    instance_count = 1
  }

  ebs_root_volume_size = 10

  log_uri = "s3://${aws_s3_bucket.emr-logging-bucket.id}"


  service_role = aws_iam_role.iam_emr_service_role.name
}


output "success" {
  value = aws_emr_cluster.data-mesh-cluster.name
}