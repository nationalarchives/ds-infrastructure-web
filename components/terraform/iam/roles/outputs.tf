output "web_request_service_record_role_arn" {
   value = aws_iam_role.web_request_service_record_role.arn
}

# output "web_request_service_record_role_name" {
#    value = aws_iam_role.web_request_service_record_role.name
# }

output "web_request_service_record_profile_name" {
   value = aws_iam_instance_profile.web_request_service_record_profile.name
}

output "web_request_service_record_profile_arn" {
   value = aws_iam_instance_profile.web_request_service_record_profile.arn
}

output "media_efs_backup_arn" {
    value = aws_iam_role.media_efs_backup.arn
}

output "web_frontend_role_id" {
    value = aws_iam_role.web_frontend_role.id
}

output "lambda_auto_run_startup_script_role_arn" {
    value = aws_iam_role.lambda_auto_run_startup_script_role.arn
}

output "lambda_wagtail_cron_trigger_role_arn"{
    value = aws_iam_role.lambda_wagtail_cron_trigger_role.arn
}

output "lambda_web_request_service_record_role_arn"{
    value = aws_iam_role.lambda_web_request_service_record_role.arn
}

output "lambda_web_rsr_cron_role_arn"{
    value = aws_iam_role.lambda_web_rsr_cron_role.arn
}

output "lambda_web_rsr_role_name" {
  value = aws_iam_role.lambda_web_rsr_cron_role.name
}

## Web Frontend role and profile outputs
output "web_frontend_role_name" {
    value = aws_iam_role.web_frontend_role.name
}

output "web_frontend_profile_name" {
    value = aws_iam_instance_profile.web_frontend_profile.name
}

output "web_frontend_instance_profile_arn" {
    value = aws_iam_instance_profile.web_frontend_profile.arn
}

## Hosprec role and profile outputs
output "web_hosprec_role_name" {
  value = aws_iam_role.web_hosprec_role.name
}

output "web_hosprec_instance_profile_arn" {
  value = aws_iam_instance_profile.web_hosprec_profile.arn
}

## Enrichment role and profile outputs
output "web_enrichment_role_name" {
  value = aws_iam_role.web_enrichment_role.name
}

output "web_enrichment_instance_profile_arn" {
  value = aws_iam_instance_profile.web_enrichment_profile.arn
}

## Reverse proxy role and profile outputs
output "web_reverse_proxy_role_name" {
  value = aws_iam_role.web_reverse_proxy_role.name
}

output "web_reverse_proxy_instance_profile_arn" {
  value = aws_iam_instance_profile.web_reverse_proxy_profile.arn
}

## Forms role and profile outputs
output "web_forms_role_name" {
  value = aws_iam_role.web_forms_role.name
}

output "web_forms_instance_profile_arn" {
  value = aws_iam_instance_profile.web_forms_profile.arn
}

## Search role and profile outputs
output "web_search_role_name" {
  value = aws_iam_role.web_search_role.name
}

output "web_search_instance_profile_arn" {
  value = aws_iam_instance_profile.web_search_profile.arn
}

## Catalogue role and profile outputs
output "web_catalogue_role_name" {
  value = aws_iam_role.web_catalogue_role.name
}

output "web_catalogue_instance_profile_arn" {
  value = aws_iam_instance_profile.web_catalogue_profile.arn
}

## Wagtail role and profile outputs
output "web_wagtail_role_name" {
  value = aws_iam_role.web_wagtail_role.name
}

output "web_wagtail_instance_profile_arn" { 
  value = aws_iam_instance_profile.web_wagtail_profile.arn
} 

## Wagtail docs role and profile outputs
output "web_wagtaildocs_role_name" {
  value = aws_iam_role.web_wagtaildocs_role.name
}

output "web_wagtaildocs_instance_profile_arn" {
  value = aws_iam_instance_profile.web_wagtaildocs_profile.arn
}

output "codedeploy_web_service_role_arn" {
    value = aws_iam_role.codedeploy_web_service_role.arn
}

output "codedeploy_web_reverse_proxy_service_role_arn" {
    value = aws_iam_role.codedeploy_web_reverse_proxy_service_role.arn
}

output "web_lambda_sync_s3_to_efs_role_arn" {
    value = aws_iam_role.web_lambda_sync_s3_to_efs.arn
}

## RSR
output "web_request_service_record_role_name" {
  value = aws_iam_role.web_request_service_record_role.name
}

output "web_request_service_record_instance_profile_arn"{
  value = aws_iam_instance_profile.web_request_service_record_profile.arn
}