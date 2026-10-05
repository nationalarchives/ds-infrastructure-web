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
