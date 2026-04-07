module "eventbridge_web_request_service" {
  source = "./eventbridge"

  lambda_arn         = module.web_docker_deployment.web_rsr_cron_lambda_arn
  scheduler_role_arn = module.roles.lambda_web_rsr_cron_role_arn
  environment        = var.environment
}
