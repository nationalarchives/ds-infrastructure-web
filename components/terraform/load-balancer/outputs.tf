output "load_balancer_arn" {
    value = aws_lb.web_services.arn
}
output "load_balancer_dns_name" {
    value = aws_lb.web_services.dns_name
}
output "lb_security_group_id" {
    value = aws_security_group.web_services_lb.id
}

output "lb_listener_arn" {
    value = aws_lb_listener.internal_http.arnvalue = ""
}
