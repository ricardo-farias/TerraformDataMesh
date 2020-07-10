output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "emr_master_security_group" {
  value = aws_security_group.emr-security-group-master.id
}

output "emr_slave_security_group" {
  value = aws_security_group.emr-security-group-slave.id
}

output "subnet_id" {
  value = aws_subnet.subnet.id
}