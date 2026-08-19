output "sns_topic_arn" {
  value = aws_sns_topic.cron_failures.arn
}
