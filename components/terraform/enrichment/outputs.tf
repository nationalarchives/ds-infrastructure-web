output "lb_internal_dns_name" {
    value = aws_lb.web_enrichment.dns_name
}

output "enrichment_lb_id" {
    value = aws_lb.web_enrichment.id
}
