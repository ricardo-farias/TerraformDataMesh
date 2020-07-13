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

output "public_subnet_1_id" {
  value = aws_subnet.public-subnet-1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public-subnet-2.id
}

output "private_subnet_id" {
  value = aws_subnet.private-subnet.id
}

output "load_balancer_security_group_arn" {
  value = aws_security_group.load-balancer-security-group-master.arn
}

output "load_balancer_security_group_id" {
  value = aws_security_group.load-balancer-security-group-master.id
}

output "redis_security_group_id" {
  value = aws_security_group.redis_security_group.id
}

output "webserver_security_group_id" {
  value = aws_security_group.webserver-security-group.id
}

output "worker_security_group_id" {
  value = aws_security_group.worker_security_group.id
}

output "scheduler_security_group_id" {
  value = aws_security_group.scheduler_security_group.id
}