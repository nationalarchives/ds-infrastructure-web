module "wagtail_migration_notifications" {
  source = "./chatbot/wagtail-migration-sns-notifications"

  environment        = var.environment
  slack_workspace_id = var.slack_workspace_id
  slack_channel_id   = var.slack_channel_id
  chatbot_name       = "wagtail-migration-failures-${var.environment}"
}

module "notifications" {
  source = "./chatbot/web-sns-notifications"

  environment        = var.environment

  slack_workspace_id = var.slack_workspace_id
  slack_channel_id   = var.slack_channel_id

  chatbot_name = "web-asg-notifications-${var.environment}"

  web_cron_notifications_sns_topic_arn = module.cron_notifications.sns_topic_arn

  wagtail_migration_failures_sns_topic_arn = module.wagtail_migration_notifications.sns_topic_arn
}
