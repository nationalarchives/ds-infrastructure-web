variable "vpc_id" {}

variable "rp_instance_cidr" {}

variable "frontend_lb_cidr" {}
variable "frontend_instance_cidr" {}

variable "db_instance_cidr" {}

variable "tags" {}
variable "wagtail_lb_cidr" {}
variable "wagtail_instance_cidr" {}

variable "enrichment_lb_cidr" {}
variable "enrichment_instance_cidr" {}

variable "enrichment_lb_id" {}
variable "enrichment_sg_id" {}