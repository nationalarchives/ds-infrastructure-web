variable "user_pool_domain" {}
variable "nationalarchives_callback_url" {}
variable "nationalarchives_logout_url" {}

module "cp-cognito" {
    source = "./cognito"

    cognito_user_pool_name = "nationalarchives-user-pool"
    user_pool_client_name = "nationalarchives-client"

    nationalarchives_callback_url = var.nationalarchives_callback_url
    nationalarchives_logout_url   = var.nationalarchives_logout_url

    user_pool_domain = var.user_pool_domain

    ses_sysdev_arn   = module.cp-ses.ses_arn
    ses_sysdev_email = module.cp-ses.ses_email_address

    certificate_arn = data.aws_ssm_parameter.us_east_1_wildcard_certificate_arn.value

    account_id = data.aws_caller_identity.current.account_id

    tags = local.tags
}
