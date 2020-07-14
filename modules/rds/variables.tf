variable "accessible" {
  type = bool
}
variable "db_username" {}
variable "db_name" {}
variable "instance_type" {}
variable "engine_version" {}
variable "db_engine" {}
variable "password" {}
variable "security_group_ids" {
  type = list(string)
}
variable "subnets" {
  type = list(string)
}
variable "identifier" {}