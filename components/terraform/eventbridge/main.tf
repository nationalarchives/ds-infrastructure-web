locals {
  is_live = var.environment == "live"

  schedule_expression = (
    local.is_live ? "rate(30 minutes)" : "cron(0/30 7-19 * * ? *)"
  )
}

##########################################
# Web RSR Expire Old Payments
##########################################
resource "aws_scheduler_schedule" "expire_old_payments" {
  count = var.lambda_arn != null && var.scheduler_role_arn != null ? 1 : 0
  name       = "expire-old-payments"
  group_name = "default"

  schedule_expression = local.schedule_expression
  schedule_expression_timezone = "Europe/London"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.lambda_arn
    role_arn = var.scheduler_role_arn

    input = jsonencode({
      task          = "expire_old_payments"
      instance_name = "web-request-service-record"
    })
    retry_policy {
    maximum_retry_attempts      = 0
    maximum_event_age_in_seconds = 60
  }
  }
}

##########################################
# Web RSR Retry Paid Requests
##########################################
resource "aws_scheduler_schedule" "retry_paid_requests" {
  count = var.lambda_arn != null && var.scheduler_role_arn != null ? 1 : 0
  name       = "retry-paid-requests"
  group_name = "default"

  schedule_expression = local.schedule_expression
  schedule_expression_timezone = "Europe/London"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.lambda_arn
    role_arn = var.scheduler_role_arn

    input = jsonencode({
      task          = "retry_paid_requests"
      instance_name = "web-request-service-record"
    })
    retry_policy {
    maximum_retry_attempts      = 0
    maximum_event_age_in_seconds = 60
  }
  }
}

##########################################
# Web RSR Retry Paid Dynamics Payments
##########################################
resource "aws_scheduler_schedule" "retry_paid_dynamics_payments" {
  count = var.lambda_arn != null && var.scheduler_role_arn != null && local.is_live ? 1 : 0

  name       = "retry-paid-dynamics-payments"
  group_name = "default"

  # Runs every hour only in production
  schedule_expression = "cron(0 * * * ? *)"
  schedule_expression_timezone = "Europe/London"

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = var.lambda_arn
    role_arn = var.scheduler_role_arn

    input = jsonencode({
      task          = "retry_paid_dynamics_payments"
      instance_name  = "web-request-service-record"
    })

    retry_policy {
      maximum_retry_attempts      = 0
      maximum_event_age_in_seconds = 60
    }
  }
}

##########################################
# Web Auto Scaling Notifications
##########################################

resource "aws_cloudwatch_event_rule" "web_asg_notifications" {
  count = local.is_live && var.enable_web_asg_notifications ? 1 : 0

  name        = "web-asg-notifications"
  description = "Capture successful Web Auto Scaling instance events"

  event_pattern = jsonencode({
    source = ["aws.autoscaling"]

    "detail-type" = [
      "EC2 Instance Launch Successful",
      "EC2 Instance Terminate Successful"
    ]
  })
}

resource "aws_cloudwatch_event_target" "web_asg_notifications" {
  count = local.is_live && var.enable_web_asg_notifications ? 1 : 0

  rule      = aws_cloudwatch_event_rule.web_asg_notifications[0].name
  target_id = "WebAsgNotificationsLambda"
  arn       = var.web_asg_notifications_lambda_arn
}

resource "aws_lambda_permission" "web_asg_notifications" {
  count = local.is_live && var.enable_web_asg_notifications ? 1 : 0

  statement_id  = "AllowEventBridgeWebAsgNotifications"
  action        = "lambda:InvokeFunction"
  function_name = var.web_asg_notifications_lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.web_asg_notifications[0].arn
}
