variable "project_name" {
  description = "Project Name"
  default = "data-mesh-poc"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
}

variable "environment" {
  default = "dev"
}

// TODO: Refactor EMR and Cleanup (Used by EMR)
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

variable "glue_db_name" {}

variable "cluster_name" {}