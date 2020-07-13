variable "project_name" {}
variable "instance_type" {}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}