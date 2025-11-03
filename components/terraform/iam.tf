module "policies" {
    source = "./iam/policies"

    deployment_s3_bucket = var.deployment_s3_bucket
    logfile_s3_bucket    = var.logfile_s3_bucket

    service = var.service

    account_id = data.aws_caller_identity.current.account_id
}

module "roles" {
    source = "./iam/roles"

    deployment_s3_policy                    = module.policies.deployment_s3_policy_arn
    lambda_web_docker_deployment_policy_arn = module.policies.lambda_web_docker_deployment_policy_arn
    org_level_logging_arn                   = data.aws_iam_policy.org_session_manager_logs_arn

    tags = local.tags
}
