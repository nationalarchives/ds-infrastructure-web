output "lb_internal_dns_name" {
    value = aws_lb.web_frontend.dns_name
}
