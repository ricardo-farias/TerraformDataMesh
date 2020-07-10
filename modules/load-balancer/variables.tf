variable "load_balancer_name" {}
variable "internal" {}
variable "load_balancer_type" {}
variable "security_groups" {
  type = list(string)
}
variable "subnets" {
  type = list(string)
}
variable "target_group_name" {}
variable "target_group_port" {}
variable "target_group_protocol" {}
variable "target_group_vpc" {}
variable "listener_port" {}
variable "listener_protocol" {}
variable "listener_type" {}