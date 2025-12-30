locals {
    service_name = "web-request-service-record"
}

variable "account_id" {}

variable "lb_listener_arn" {}
variable "x_target_header" {}
variable "host_header" {}

variable "lb_name" {}
variable "route53_zone" {}
variable "c_name" {}

variable "vpc_id" {}
variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "root_block_device_size" {}

variable "patch_group" {}
variable "deployment_group" {}
variable "auto_switch_on" {}
variable "auto_switch_off" {}

variable "asg_max_size" {}
variable "asg_min_size" {}
variable "asg_desired_capacity" {}
variable "asg_health_check_grace_period" {}
variable "asg_health_check_type" {}

variable "deployment_s3_bucket" {}
variable "folder_s3_key" {}
variable "foi1939_register_write_policy_arn" {}

variable "asg_tags" {}
variable "tags" {}

variable "ses_nationalarchives_gov_uk_domain_arn" {}

variable "web_request_service_record_sg_id" {}
variable "org_level_logging_arn" {}
