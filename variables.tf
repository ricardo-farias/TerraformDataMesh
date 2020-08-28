variable "name" {
  description = "Name of the DashMesh"
}

variable "region" {
  description = "AWS region to deploy resources"
}

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

variable "error_folder_name" {}
variable "raw_folder_name" {}
variable "canonical_folder_name" {}

variable "cluster_name" {}