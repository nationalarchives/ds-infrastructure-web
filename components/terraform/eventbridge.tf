module "eventbridge_web_request_service" {
  source = "./eventbridge"

  lambda_arn         = module.lambda.web_rsr_cron_lambda_arn
  scheduler_role_arn = module.roles.lambda_web_rsr_cron_role_arn
  environment        = var.environment
}

module "eventbridge_platform_redis" {
  source = "./eventbridge"

  redis_dns_lambda_arn = module.lambda.platform_redis_dns_update_lambda_arn
  environment          = var.environment
}
