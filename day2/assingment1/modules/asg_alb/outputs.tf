
output "dns_name" {
  value = aws_lb.alb.dns_name
}

output "server_sg_id" {
  value = aws_security_group.server_sg.id
}
