module "policies" {
    source = "./iam/policies"

    deployment_s3_bucket = var.deployment_s3_bucket
    logfile_s3_bucket    = var.logfile_s3_bucket

    rp_deployment_s3_root = var.rp_deployment_s3_root
    rp_logfile_s3_root    = var.rp_logfile_s3_root

    service = var.service

    account_id = data.aws_caller_identity.current.account_id
}

module "roles" {
    source = "./iam/roles"

    deployment_s3_policy                     = module.policies.deployment_s3_policy_arn
    rp_config_s3_policy_arn                  = module.policies.rp_config_s3_policy_arn
    lambda_web_docker_deployment_policy_arn = module.policies.lambda_web_docker_deployment_policy_arn

    tags = local.tags
}
