variable "name" {}
variable "subnet_id" {}
variable "key_name" {}
variable "release_label" {}
variable "applications" {
  type = list(string)
}
variable "master_instance_type" {}
variable "core_instance_type" {}
variable "core_instance_count" {}
variable "emr_master_security_group" {}
variable "emr_slave_security_group" {}
variable "emr_ec2_instance_profile" {}
variable "emr_service_role" {}
variable "logging_bucket" {}