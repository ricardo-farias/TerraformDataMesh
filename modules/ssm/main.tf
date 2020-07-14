resource "aws_ssm_parameter" "parameter" {
  name  = var.name
  type  = var.type
  value = var.value
}