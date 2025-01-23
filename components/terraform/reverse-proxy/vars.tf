variable "vpc_id" {}
variable "vpc_cidr" {}
variable "public_subnet_a_id" {}
variable "public_subnet_b_id" {}
variable "private_subnet_a_id" {}
variable "private_subnet_b_id" {}

variable "lb_sg_id" {}
variable "profile_arn" {}
variable "sg_ids" {}

variable "efs_dns_name" {}
variable "efs_mount_dir" {}

# launch configuration - reverse proxy
#
variable "image_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "root_block_device_size" {}
variable "nginx_folder_s3_key" {}

# auto-scaling
#
variable "asg_max_size" {}
variable "asg_min_size" {}
variable "asg_desired_capacity" {}
variable "asg_health_check_grace_period" {}
variable "asg_health_check_type" {}

variable "asg_tags" {}

variable "deployment_s3_bucket" {}
variable "logfile_s3_bucket" {}

variable "ssl_cert_arn" {}

variable "tags" {}

variable "custom_header_value" {}
variable "custom_header_name" {}
