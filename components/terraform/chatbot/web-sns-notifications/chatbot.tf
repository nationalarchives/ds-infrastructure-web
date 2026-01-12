resource "aws_sns_topic" "web_asg_notifications" {
  count = var.environment == "live" ? 1 : 0
  name  = "web-asg-notifications-${var.environment}"
}

resource "aws_chatbot_slack_channel_configuration" "web_asg_notifications" {
  count = var.environment == "live" ? 1 : 0

  configuration_name               = var.chatbot_name
  slack_team_id = var.slack_workspace_id
  slack_channel_id   = var.slack_channel_id

  sns_topic_arns = [
    aws_sns_topic.web_asg_notifications[0].arn
  ]

  iam_role_arn = aws_iam_role.chatbot_role[0].arn
  logging_level = "INFO"
}
