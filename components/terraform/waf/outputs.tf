output "web_waf_info" {
    value = aws_wafv2_web_acl.web.arn
}
output "web_acl_arn" {
    value = aws_wafv2_web_acl.web.arn
}
output "access_ip_set_arn" {
    value = aws_wafv2_ip_set.web_access.arn
}
