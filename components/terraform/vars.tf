variable "deployment_s3_bucket" {}
variable "route53_zone" {}
variable "s3_deployment_rp_nginx_runtime_key" {}
variable "logfile_s3_bucket" {}
variable "rp_logfile_s3_root" {}
variable "rp_deployment_s3_root" {}
variable "service" {}
variable "enrichment_deployment_s3_root" {}
variable "enrichment_logfile_s3_root" {}
variable "private_record" {}
variable "frontend_deployment_s3_root" {}
variable "frontend_logfile_s3_root" {}
variable "public_domain" {}
variable "region" {}
variable "db_record" {}
# variable "cf_dist" {}
variable "internal_domain_name" {}
variable "enrichment_efs_mount_dir" {}
variable "frontend_efs_mount_dir" {}
variable "on_prem_cidrs" {}