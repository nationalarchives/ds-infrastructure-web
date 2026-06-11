## -----------------------------------------------------------------------------
## variable definitions
## -----------------------------------------------------------------------------
variable "wildcard_certificate_arn" {}
#variable "web_waf_info" {}
variable "default_tags" {}

variable "web_monthly_update_policy_id" {}
variable "web_weekly_update_policy_id" {}
variable "web_5_minute_update_policy_id" {}

variable "web_reverse_proxy_lb_dns_name" {}

variable "account" {}
variable "environment" {}

variable "custom_header_name" {}
variable "custom_header_value" {}
