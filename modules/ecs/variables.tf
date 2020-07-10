variable "family_name" {}
variable "task_execution_arn" {}
variable "network_mode" {}
variable "cpu" {}
variable "memory" {}
variable "requires_compatibilities" {
  type = list(string)
}
variable "hostPort" {}
variable "command" {}
variable "fernet_key" {}
variable "redis_host" {}
variable "image" {}
variable "service_name" {}
variable "cluster_id" {}
variable "desired_count" {}
variable "launch_type" {}
//variable "load_balancer_target_group_arn" {}
//variable "load_balancer_container_name" {}
//variable "load_balancer_container_port" {}
variable "subnets" {
  type = list(string)
}
variable "security_groups" {
  type = list(string)
}
variable "assign_public_ip" {}