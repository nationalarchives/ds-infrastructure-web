output "sns_topic_arn" {
  value = aws_sns_topic.cron_failures.arn
}

output "chatbot_role_arn" {
  value = aws_iam_role.chatbot_role.arn
}
