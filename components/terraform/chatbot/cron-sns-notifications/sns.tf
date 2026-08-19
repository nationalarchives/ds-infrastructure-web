resource "aws_sns_topic" "cron_failures" {
  name = "web-cron-failures-${var.environment}"
}
