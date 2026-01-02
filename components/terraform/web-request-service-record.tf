variable "web_request_service_record_instance_type" {}
variable "web_request_service_record_root_block_device_size" {}

variable "web_request_service_record_asg_max_size" {}
variable "web_request_service_record_asg_min_size" {}
variable "web_request_service_record_asg_desired_capacity" {}
variable "web_request_service_record_asg_health_check_grace_period" {}
variable "web_request_service_record_asg_health_check_type" {}

variable "web_request_service_record_auto_switch_off" {}
variable "web_request_service_record_auto_switch_on" {}
variable "web_request_service_record_deployment_group" {}
variable "web_request_service_record_patch_group" {}
variable "web_request_service_record_deployment_s3_bucket" {}
variable "web_request_service_record_folder_s3_key" {}
variable "web_request_service_record_deploy"{}


module "web-request-service-record" {
    count = var.web_request_service_record_deploy
    source = "./web-request-service-record"

    account_id = data.aws_caller_identity.current.account_id
    ami_id = data.aws_ami.web_request_service_record_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "web-request-service-record"
    host_header = "web-rsr.${var.environment}.local"
    lb_name = module.load-balancer.load_balancer_dns_name
    route53_zone = var.route53_zone
    c_name = "web-rsr.${var.environment}.local"

    web_request_service_record_sg_id = module.sgs.web_request_service_record_sg_id
    org_level_logging_arn = data.aws_iam_policy.org_session_manager_logs.arn

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value
    enable_monitoring = var.enable_monitoring

    asg_max_size = var.web_request_service_record_asg_max_size
    asg_min_size = var.web_request_service_record_asg_min_size
    asg_desired_capacity = var.web_request_service_record_asg_desired_capacity
    asg_health_check_grace_period = var.web_request_service_record_asg_health_check_grace_period
    asg_health_check_type = var.web_request_service_record_asg_health_check_type
    instance_type = var.web_request_service_record_instance_type
    key_name = "web-frontend-${var.environment}-eu-west-2"
    root_block_device_size = "100"

    auto_switch_off = var.web_request_service_record_auto_switch_off
    auto_switch_on = var.web_request_service_record_auto_switch_on
    deployment_group = var.web_request_service_record_deployment_group
    patch_group = var.web_request_service_record_patch_group

    deployment_s3_bucket = var.web_request_service_record_deployment_s3_bucket
    folder_s3_key = var.web_request_service_record_folder_s3_key

    foi1939_register_write_policy_arn = data.aws_ssm_parameter.foi1939_register_write_policy_arn.value

    ses_nationalarchives_gov_uk_domain_arn = data.aws_ssm_parameter.ses_nationalarchives_gov_uk_domain_arn.value

    asg_tags = local.asg_default_tags
    tags = local.tags
}
