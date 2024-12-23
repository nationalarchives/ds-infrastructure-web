output "deployment_s3_policy_arn" {
    value = aws_iam_policy.deployment_s3.arn
}

output "rp_config_s3_policy_arn" {
    value = aws_iam_policy.deployment_s3.arn
}

output "lambda_web_docker_deployment_policy_arn" {
    value = aws_iam_policy.lambda_web_docker_deployment_policy.arn
}
