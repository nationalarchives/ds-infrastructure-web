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

output "application_parameter_store_policy_arn" {
  value = aws_iam_policy.application_parameter_store_policy.arn
}

output "web_enrichment_deployment_s3_policy_arn" {
  value = aws_iam_policy.web_enrichment_deployment_s3.arn
}

output "codedeploy_web_access_policy" {
  value = aws_iam_policy.codedeploy_web_access_policy.arn
}

output "codedeploy_web_asg_policy_arn" {
  value = aws_iam_policy.codedeploy_web_asg_policy.arn
}

output "codedeploy_web_s3_access_arn" {
  value = aws_iam_policy.codedeploy_web_s3_access.arn
}

output "codedeploy_web_reverse_proxy_access_policy" {
  value = aws_iam_policy.codedeploy_web_reverse_proxy_access_policy.arn
}

output "codedeploy_web_reverse_proxy_asg_policy_arn" {
  value = aws_iam_policy.codedeploy_web_reverse_proxy_asg_policy.arn
}

output "codedeploy_web_reverse_proxy_s3_access_arn" {
  value = aws_iam_policy.codedeploy_web_reverse_proxy_s3_access.arn
}

# output "s3_deployment_source_web_static_content_read_arn" {
#   value = aws_iam_policy.s3_deployment_source_web_static_content_read.arn
# }
