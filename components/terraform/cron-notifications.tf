module "cron_notifications" {
  source = "./chatbot/cron-sns-notifications"

  environment        = var.environment
  slack_workspace_id = var.slack_workspace_id
  slack_channel_id   = var.slack_channel_id
  chatbot_name       = "web-cron-failures-${var.environment}"
}
