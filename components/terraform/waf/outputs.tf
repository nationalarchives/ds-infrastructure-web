output "web_waf_info" {
    value = aws_wafv2_web_acl.web.arn
}
output "web_acl_arn" {
    value = aws_wafv2_web_acl.web.arn
}
output "access_ip_set_arn" {
    value = aws_wafv2_ip_set.web_access.arn
}
output "exception_ip_set_arn" {
    value = aws_wafv2_ip_set.web_exceptions.arn
}
output "wagtail_admin_ip_set_arn" {
    value = aws_wafv2_ip_set.wagtail_admins.arn
}
output "wp_admin_ip_set_arn" {
    value = aws_wafv2_ip_set.wp_admins.arn
}
output "torchbox_seo_audit_ip_set_arn" {
    value = aws_wafv2_ip_set.torchbox_seo_audit
}
