output "emr_master_security_group" {
  value = aws_security_group.emr-security-group-master.id
}

output "emr_slave_security_group" {
  value = aws_security_group.emr-security-group-slave.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_security_group.id
}