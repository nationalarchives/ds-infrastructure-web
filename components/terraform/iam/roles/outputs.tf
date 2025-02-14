output "frontend_profile_name" {
    value = aws_iam_instance_profile.frontend_profile.name
}
output "frontend_profile_arn" {
    value = aws_iam_instance_profile.frontend_profile.arn
}
output "rp_profile_name" {
    value = aws_iam_instance_profile.rp_profile.name
}
output "rp_profile_arn" {
    value = aws_iam_instance_profile.rp_profile.arn
}

output "media_efs_backup_arn" {
    value = aws_iam_role.media_efs_backup.arn
}

output "frontend_role_id" {
    value = aws_iam_role.frontend_role.id
}
output "rp_role_id" {
    value = aws_iam_role.rp_role.arn
}
output "lambda_web_docker_deployment_role_arn" {
    value = aws_iam_role.lambda_web_docker_deployment_role.arn
}
output "lambda_auto_run_startup_script_role_arn" {
    value = aws_iam_role.lambda_auto_run_startup_script_role.arn
}