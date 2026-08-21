resource "aws_chatbot_slack_channel_configuration" "cron_failures" {
  count = var.environment == "live" ? 0 : 1

  configuration_name = var.chatbot_name

  slack_team_id    = var.slack_workspace_id
  slack_channel_id = var.slack_channel_id

  sns_topic_arns = [
    aws_sns_topic.cron_failures.arn
  ]

  iam_role_arn  = aws_iam_role.chatbot_role.arn
  logging_level = "INFO"
}
