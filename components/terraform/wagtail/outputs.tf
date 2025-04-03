output "wagtail_lb_id" {
    value = aws_lb.wagtail.id
}
output "lb_internal_dns_name" {
  value = aws_lb.wagtail.dns_name
}

    