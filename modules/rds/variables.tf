variable "accessible" {
  type = bool
  default = false
}

variable "name" {
  default = "data-mesh-poc"
}

variable "username" {}
variable "password" {}

variable "instance_type" {
  default = "db.t2.micro"
}

variable "db_engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "11.6"
}

variable "private_subnets" {
}

variable "identifier" {
  default = "airflow"
}
variable "project_name" {}
variable "environment" {}