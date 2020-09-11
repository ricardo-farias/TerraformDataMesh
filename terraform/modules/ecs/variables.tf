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
variable "target_group_arn" {}
variable "subnets" { type = list(string)}
variable "redis_security_group_id" {}
variable "worker_security_group_id" {}
variable "scheduler_security_group_id" {}
variable "webserver_security_group_id" {}
variable "load_balancer" {}
variable "elastic_cache" {}