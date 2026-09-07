output "process_submitted_files_queue_arn" {
  value = var.environment == "live" ? aws_sqs_queue.process_submitted_files_queue[0].arn : null
}

output "process_submitted_files_queue_url" {
  value = var.environment == "live" ? aws_sqs_queue.process_submitted_files_queue[0].id : null
}

output "web_rsr_cron_lambda_arn" {
  value = aws_lambda_function.web_rsr_cron.arn
}

output "platform_redis_dns_update_lambda_arn" {
  value = aws_lambda_function.platform_redis_dns_update.arn
}

output "platform_redis_dns_update_lambda_name" {
  value = aws_lambda_function.platform_redis_dns_update.function_name
}
