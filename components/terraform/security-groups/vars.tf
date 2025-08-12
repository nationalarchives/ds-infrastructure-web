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


variable "redis_lb_cidr" {}
variable "redis_instance_cidr" {}

variable "redis_lb_id" {}
variable "redis_sg_id" {}

variable "catalogue_lb_cidr"{}
variable "catalogue_instance_cidr"{}

variable "search_lb_cidr"{}
variable "search_instance_cidr"{}