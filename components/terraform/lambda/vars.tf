variable "web_docker_deployment_role_arn" {}
variable "subnet_ids" {}
variable "security_group_ids" {}
variable "layers" {}

variable "environment" {}

variable "tags" {}
variable "foi_s3_bucket_arn" {}
variable "auto_run_startup_script_role_arn" {}
variable "wagtail_cron_trigger_role_arn"{}
variable "foi_s3_bucket"{}
variable "web_request_service_record_role_arn" {}