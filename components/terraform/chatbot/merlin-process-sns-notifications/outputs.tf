output "sns_topic_arn" {
  value = var.environment == "live" ? aws_sns_topic.merlin_process_failures[0].arn : null
}
