variable "deployment_s3_bucket" {}
variable "route53_zone" {}
variable "logfile_s3_bucket" {}
variable "service" {}
variable "web_enrichment_deployment_s3_root" {}
variable "web_enrichment_logfile_s3_root" {}
variable "private_record" {}
variable "web_frontend_deployment_s3_root" {}
variable "web_frontend_logfile_s3_root" {}
variable "public_domain" {}
variable "region" {}
variable "db_record" {}
variable "cf_dist" {}
variable "internal_domain_name" {}
variable "web_enrichment_efs_mount_dir" {}
variable "web_frontend_efs_mount_dir" {}
variable "on_prem_cidrs" {}
variable "redis_efs_mount_dir" {}
variable "foi_s3_bucket" {}
variable "lambda_web_request_sqs_queue_arn" {}
variable "foi_s3_bucket_arn" {}
variable "process_submitted_files_queue_arn" {}
variable "process_submitted_files_queue_url" {}

variable "wp_secretsmanager_secret_arn" {
    description = "Wordpress secrets"
}
variable "default_tags"{}
# cloudfront
variable "cf_default_ttl" {
    default = 300
}
variable "cf_max_ttl" {
    default = 1200
}
variable "cf_min_ttl" {
    default = 60
}
variable "help_with_your_research_default_ttl" {
    default = 3600
}
variable "help_with_your_research_max_ttl" {
    default = 86400
}
variable "help_with_your_research_min_ttl" {
    default = 300
}
variable "web_5_minute_update_default_ttl" {
    default = 300
}
variable "web_5_minute_update_max_ttl" {
    default = 1200
}
variable "web_5_minute_update_min_ttl" {
    default = 60
}
