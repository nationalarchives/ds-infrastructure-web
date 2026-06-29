output "web_emergency_rule_group_arn" {
    value = aws_wafv2_rule_group.web_known_ips_rg.arn
}
