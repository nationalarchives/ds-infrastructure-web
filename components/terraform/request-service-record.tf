variable "request_service_record_instance_type" {}
variable "request_service_record_root_block_device_size" {}

variable "request_service_record_asg_max_size" {}
variable "request_service_record_asg_min_size" {}
variable "request_service_record_asg_desired_capacity" {}
variable "request_service_record_asg_health_check_grace_period" {}
variable "request_service_record_asg_health_check_type" {}

variable "request_service_record_auto_switch_off" {}
variable "request_service_record_auto_switch_on" {}
variable "request_service_record_deployment_group" {}
variable "request_service_record_patch_group" {}
variable "request_service_record_deployment_s3_bucket" {}
variable "request_service_record_folder_s3_key" {}


module "request-service-record" {
    source = "./request-service-record"

    ami_id = data.aws_ami.request_service_record_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "request-service-record"
    host_header = "request-service-record.${var.environment}.local"

    request_service_record_sg_id = module.sgs.request_service_record_sg_id
    org_level_logging_arn = data.aws_iam_policy.org_session_manager_logs_arn

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    asg_max_size = var.request_service_record_asg_max_size
    asg_min_size = var.request_service_record_asg_min_size
    asg_desired_capacity = var.request_service_record_asg_desired_capacity
    asg_health_check_grace_period = var.request_service_record_asg_health_check_grace_period
    asg_health_check_type = var.request_service_record_asg_health_check_type

    instance_type = var.request_service_record_instance_type
    key_name = "web-frontend-${var.environment}-eu-west-2"
    root_block_device_size = "100"

    auto_switch_off = var.request_service_record_auto_switch_off
    auto_switch_on = var.request_service_record_auto_switch_on
    deployment_group = var.request_service_record_deployment_group
    patch_group = var.request_service_record_patch_group

    deployment_s3_bucket = var.request_service_record_deployment_s3_bucket
    folder_s3_key = var.request_service_record_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
