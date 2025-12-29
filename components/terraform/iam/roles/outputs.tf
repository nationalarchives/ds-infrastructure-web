output "web_frontend_profile_name" {
    value = aws_iam_instance_profile.web_frontend_profile.name
}
output "web_frontend_profile_arn" {
    value = aws_iam_instance_profile.web_frontend_profile.arn
}
#output "request_service_record_role_arn" {
#    value = aws_iam_role.request_service_record_role.arn
#}
#output "request_service_record_role_name" {
#    value = aws_iam_role.request_service_record_role.name
#}
#output "request_service_record_profile_name" {
#    value = aws_iam_instance_profile.request_service_record_profile.name
#}
#output "request_service_record_profile_arn" {
#    value = aws_iam_instance_profile.request_service_record_profile.arn
#}

output "media_efs_backup_arn" {
    value = aws_iam_role.media_efs_backup.arn
}

output "web_frontend_role_id" {
    value = aws_iam_role.web_frontend_role.id
}
output "lambda_web_docker_deployment_role_arn" {
    value = aws_iam_role.lambda_web_docker_deployment_role.arn
}
output "lambda_auto_run_startup_script_role_arn" {
    value = aws_iam_role.lambda_auto_run_startup_script_role.arn
}
output "lambda_wagtail_cron_trigger_role_arn"{
    value = aws_iam_role.lambda_wagtail_cron_trigger_role.arn
}
