variable "project_name" {
  description = "Project Name"
  default = "data-mesh-poc"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
}

// TODO: Remove Subnet ID (Used by EMR)
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
variable "covid_data_bucket_name" {}
variable "citi_bike_data_bucket_name" {}
variable "logging_bucket_name" {}

variable "cluster_name" {}
variable "environment" {
  default = "dev"
}