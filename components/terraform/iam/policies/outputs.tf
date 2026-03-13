output "deployment_s3_policy_arn" {
  value = aws_iam_policy.deployment_s3.arn
}

output "lambda_web_docker_deployment_policy_arn" {
  value = aws_iam_policy.lambda_web_docker_deployment_policy.arn
}

output "web_request_s3_copy_policy_arn" {
  value = aws_iam_policy.web_request_s3_copy_policy.arn
}

output "lambda_web_request_rsr_sqs_arn" {
  value = length(aws_iam_policy.lambda_web_request_rsr_sqs) > 0 ? aws_iam_policy.lambda_web_request_rsr_sqs[0].arn : null
}