module "emergency_group" {
    count = var.waf_rule_group_emergency ? 1 : 0
    source = "./waf-rule-groups/web-emergency"
}
