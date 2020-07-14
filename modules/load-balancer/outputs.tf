output "load_balancer_arn" {
  value = aws_lb.load-balancer.arn
}

output "load_balancer_id" {
  value = aws_lb.load-balancer.id
}

output "load_balancer_name" {
  value = aws_lb.load-balancer.name
}

output "load_balancer_dns" {
  value = aws_lb.load-balancer.dns_name
}

output "listener_id" {
  value = aws_lb_listener.listener.id
}

output "listener_arn" {
  value = aws_lb_listener.listener.arn
}

output "target_group_id" {
  value = aws_lb_target_group.target-group.id
}

output "target_group_arn" {
  value = aws_lb_target_group.target-group.arn
}

output "load_balancer" {
  value = aws_lb.load-balancer
}
