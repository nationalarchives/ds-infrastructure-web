resource "aws_scheduler_schedule" "expire_old_payments" {
  name       = "expire-old-payments"
  group_name = "default"

  schedule_expression = "rate(30 minutes)"
  start_date = "2026-03-31T16:00:00Z"
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

resource "aws_scheduler_schedule" "retry_paid_requests" {
  name       = "retry-paid-requests"
  group_name = "default"

  schedule_expression = "rate(30 minutes)"
  start_date = "2026-03-31T16:00:00Z"
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