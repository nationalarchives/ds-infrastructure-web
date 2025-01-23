## -----------------------------------------------------------------------------
## variable definitions

variable "cf_dist" {}
variable "lb_dns_name" {}

variable "wildcard_certificate_arn" {}

# customer header used to limit traffic to load balancers
variable "custom_header_name" {}
variable "custom_header_value" {}

variable "tags" {}

variable "web_waf_info" {
  description = "Taken from aws ssm parameter store data"
  default     = {}
}

# ======================================================================================================================
# Local Values - Sets Default Tags
# ======================================================================================================================
