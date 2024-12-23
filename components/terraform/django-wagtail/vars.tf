variable "vpc_id" {}
variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "lb_sg_id" {}
variable "efs_id" {}

variable "ami_id" {}
variable "instance_type" {}
variable "instance_profile_arn" {}
variable "key_name" {}
variable "sg_ids" {}
variable "root_block_device_size" {}

variable "efs_mount_dir" {}
variable "efs_dns_name" {}

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

variable "asg_tags" {}

variable "tags" {}
