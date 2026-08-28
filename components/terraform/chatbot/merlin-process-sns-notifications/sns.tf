resource "aws_sns_topic" "merlin_process_failures" {

  count = var.environment == "live" ? 1 : 0

  name = "merlin-process-failures-${var.environment}"
}
