variable "tags" {}
variable "environment" {}

variable "site_ips" {
    description = "ip addresses opposing to general waf behaviour"
}

# rule switches
# -------------
variable "waf_rule_default_action_allow" {
    description = "indicating the general waf behavior"
    default     = true
}
variable "waf_rule_shield_advanced_active" {
    default = false
}
