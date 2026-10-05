output "sns_topic_arn" {
  value = aws_sns_topic.wagtail_migration_failures.arn
}
