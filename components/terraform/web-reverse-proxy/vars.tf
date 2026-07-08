variable "lb_listener_arn" {}
variable "x_target_header" {}
variable "host_header" {}

variable "vpc_id" {}
variable "vpn_cidr" {}
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
variable "enable_monitoring" {}

variable "asg_max_size" {}
variable "asg_min_size" {}
variable "asg_desired_capacity" {}
variable "asg_health_check_grace_period" {}
variable "asg_health_check_type" {}

variable "web_reverse_proxy_autoscaling_policy_name_prefix" {}
variable "autoscaling_policy_name_prefix" {}
variable "default_cooldown" {}
variable "scale_in_threshold" {}
variable "scale_out_threshold" {}
variable "enable_autoscaling" {}
variable "asg_notifications_sns_arn" {}

variable "deployment_s3_bucket" {}
variable "folder_s3_key" {}

variable "asg_tags" {}
variable "tags" {}

#variable "efs_dns_name" {}
variable "web_reverse_proxy_sg_id" {}
variable "web_reverse_proxy_wagtail_efs_mount_dir" {}
variable "efs_mount_dir" {}
variable "service" {}
variable "lb_sg_id" {}
variable "public_subnet_a_id" {}

variable "public_subnet_b_id" {}
variable "public_ssl_cert_arn" {}
variable "public_domain_name" {}
variable "sub_sub_domain_ssl_cert_arn" {}
variable "web_reverse_proxy_lb_security_group_id" {}

variable "web_reverse_proxy_role_name" {}
variable "web_reverse_proxy_instance_profile_arn" {}
variable "mount_target" {}
variable "mount_wagtail_media" {}
