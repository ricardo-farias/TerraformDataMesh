variable "name" {}
variable "region" {}
variable "subnet_id" {}
variable "vpc_id" {}
variable "key_name" {}
variable "release_label" {}
variable "applications" {
  type = list
}
variable "master_instance_type" {}
variable "core_instance_type" {}
variable "core_instance_count" {}
variable "ingress_cidr_blocks" {}
variable "database_name" {}
variable "athena_bucket_name" {}
variable "data_bucket_name" {}
variable "logging_bucket_name" {}