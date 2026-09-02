##########################################
# Platform Redis DNS Update
##########################################

resource "aws_cloudwatch_event_rule" "platform_redis_dns_update" {
  count = var.redis_dns_lambda_arn != null ? 1 : 0

  name        = "platform-redis-dns-update"
  description = "Trigger Redis DNS update when Platform Redis instance starts"

  event_pattern = jsonencode({
    source      = ["aws.ec2"]
    detail-type = ["EC2 Instance State-change Notification"]

    detail = {
      state = ["running"]
    }
  })
}

resource "aws_cloudwatch_event_target" "platform_redis_dns_update" {
  count = var.redis_dns_lambda_arn != null ? 1 : 0
  rule = aws_cloudwatch_event_rule.platform_redis_dns_update[count.index].name
  arn  = var.redis_dns_lambda_arn
}

resource "aws_lambda_permission" "platform_redis_dns_update" {
  count = var.redis_dns_lambda_arn != null ? 1 : 0

  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.redis_dns_lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.platform_redis_dns_update[count.index].arn
}
