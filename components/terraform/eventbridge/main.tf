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
  count = local.is_live ? 1 : 0

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
