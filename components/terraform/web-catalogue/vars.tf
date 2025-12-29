variable "lb_listener_arn" {}
variable "x_target_header" {}
variable "host_header" {}

variable "vpc_id" {}
variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "instance_cidr" {}
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
variable "web_catalogue_autoscaling_policy_name_prefix" {}
variable "autoscaling_policy_name_prefix" {}
variable "default_cooldown" {}
variable "scale_in_threshold" {}
variable "scale_out_threshold" {}
variable "enable_autoscaling" {}

variable "deployment_s3_bucket" {}
variable "folder_s3_key" {}

variable "asg_tags" {}
variable "tags" {}
variable "web_catalogue_sg_id" {}

variable "web_catalogue_efs_mount_dir" {}
variable "efs_dns_name" {}
