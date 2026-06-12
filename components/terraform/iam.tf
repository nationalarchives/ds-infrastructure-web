module "policies" {
    source = "./iam/policies"
    environment = var.environment
    deployment_s3_bucket = var.deployment_s3_bucket
    logfile_s3_bucket    = var.logfile_s3_bucket
    foi_s3_bucket_arn    = var.foi_s3_bucket
    service              = var.service
    foi_s3_bucket        = var.foi_s3_bucket
    lambda_role_name = module.roles.lambda_web_rsr_role_name
    lambda_web_request_sqs_queue_arn  = var.lambda_web_request_sqs_queue_arn
    process_submitted_files_queue_arn = var.process_submitted_files_queue_arn
    process_submitted_files_queue_url = var.process_submitted_files_queue_url
    s3_deployment_source_arn = data.aws_ssm_parameter.s3_deployment_source_arn
    account_id = data.aws_caller_identity.current.account_id
    tags = local.tags
}

module "roles" {
    source = "./iam/roles"
    environment = var.environment
    deployment_s3_policy                    = module.policies.deployment_s3_policy_arn
    lambda_web_docker_deployment_policy_arn = module.policies.lambda_web_docker_deployment_policy_arn
    org_level_logging_arn                   = data.aws_iam_policy.org_session_manager_logs.arn
    foi_s3_bucket                           = var.foi_s3_bucket
    web_request_s3_copy_policy_arn          = module.policies.web_request_s3_copy_policy_arn
    lambda_web_request_rsr_sqs_arn          = module.policies.lambda_web_request_rsr_sqs_arn
    application_parameter_store_policy_arn  = module.policies.application_parameter_store_policy_arn
    web_enrichment_deployment_s3_policy_arn = module.policies.web_enrichment_deployment_s3_policy_arn

    codedeploy_web_asg_policy_arn = module.policies.codedeploy_web_asg_policy_arn
    codedeploy_web_s3_access_arn  = module.policies.codedeploy_web_s3_access_arn
    codedeploy_web_access_policy  = module.policies.codedeploy_web_access_policy

    codedeploy_web_reverse_proxy_asg_policy_arn = module.policies.codedeploy_web_reverse_proxy_asg_policy_arn
    codedeploy_web_reverse_proxy_access_policy  = module.policies.codedeploy_web_reverse_proxy_access_policy
    
    tags = local.tags
}
