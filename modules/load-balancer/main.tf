resource "aws_lb" "load-balancer" {
  name               = var.load_balancer_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets
}

resource "aws_lb_target_group" "target-group" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.target_group_vpc
  health_check {
    path = "/"
    matcher = var.matcher
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = var.listener_type
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}