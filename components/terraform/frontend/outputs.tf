output "lb_internal_dns_name" {
    value = aws_lb.web_frontend.dns_name
}

output "frontend_lb_sg_id" {
   value = aws_security_group.frontend_lb.id
}
output "frontend_sg_id" {
   value = aws_security_group.frontend.id
}
