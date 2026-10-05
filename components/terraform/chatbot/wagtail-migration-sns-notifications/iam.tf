data "aws_iam_role" "chatbot_role" {
  name = "cron-chatbot-role-${var.environment}"
}
