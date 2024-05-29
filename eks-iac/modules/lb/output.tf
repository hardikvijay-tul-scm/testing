output "lb_target_arn" {
  value = aws_lb.nlb.arn
}
output "lb_dns_name"{
    value = aws_lb.nlb.dns_name
}
