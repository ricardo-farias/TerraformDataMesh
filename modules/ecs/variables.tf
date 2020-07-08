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
