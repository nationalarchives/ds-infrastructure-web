variable "deployment_s3_policy" {}
variable "org_level_logging_arn" {}
variable "environment" {}
variable "tags" {}
variable "foi_s3_bucket" {}
variable "web_request_s3_copy_policy_arn" {}
variable "lambda_web_request_rsr_sqs_arn" {}
variable "application_parameter_store_policy_arn" {}
variable "web_enrichment_deployment_s3_policy_arn" {}

# codedeploy
variable "codedeploy_web_asg_policy_arn" {}
variable "codedeploy_web_s3_access_arn" {}
variable "codedeploy_web_access_policy" {}
#variable "discovery_source_access_policy" {}
variable "codedeploy_web_reverse_proxy_asg_policy_arn" {}
variable "codedeploy_web_reverse_proxy_access_policy" {}
#variable "s3_deployment_source_static_content_read_arn" {}
