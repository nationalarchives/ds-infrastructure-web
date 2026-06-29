variable "tags" {}
variable "environment" {}

variable "site_ips" {
    description = "ip addresses opposing to general waf acl action"
    default = []
}
variable "exception_site_ips" {
    description = "ip addresses exception to site_ips"
    default = []
}
variable "wp_admin_ips" {
    description = "ip addresses of wordpress admins"
    default = []
}
variable "wagtail_admin_ips" {
    description = "ip addresses of wagtail admins"
    default = []
}
variable "tourchbox_seo_audit_ips" {
    description = "ip addresses of tourchbox seo audit"
    default = []
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
