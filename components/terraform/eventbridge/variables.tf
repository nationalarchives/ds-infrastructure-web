variable "lambda_arn" {
  type    = string
  default = null
}

variable "scheduler_role_arn" {
  type    = string
  default = null
}

variable "environment" {
  type = string
}

variable "redis_dns_lambda_arn" {
  type    = string
  default = null
}

variable "enable_redis_dns" {
  type    = bool
  default = false
}

variable "web_asg_notifications_lambda_arn" {
  description = "ARN of shared Web ASG notifications Lambda"
  type        = string
  default     = null
}

variable "enable_web_asg_notifications" {
  description = "Enable Web Auto Scaling EventBridge notifications"
  type        = bool
  default     = false
}
