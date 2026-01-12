output "sns_topic_arn" {
  value       = var.environment == "live" ? aws_sns_topic.web_asg_notifications[0].arn : ""
  description = "SNS topic ARN for live environment autoscaling notifications"
}

output "chatbot_name" {
  value = var.environment == "live" ? aws_chatbot_slack_channel_configuration.web_asg_notifications[0].configuration_name : ""
  description = "AWS Chatbot Slack configuration name"
}
