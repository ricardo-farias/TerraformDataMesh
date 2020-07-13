variable "task_execution_arn" {}
variable "network_mode" {}
variable "requires_compatibilities" {
  type = list(string)
}
variable "fernet_key" {}
variable "redis_host" {}
variable "image" {}
variable "cluster_id" {}
variable "launch_type" {}
variable "load_balancer_name" {}
variable "public_subnet" { type = string}
variable "private_subnet" { type = string}
variable "redis_security_group_id" {}
variable "worker_security_group_id" {}
variable "scheduler_security_group_id" {}
variable "webserver_security_group_id" {}
