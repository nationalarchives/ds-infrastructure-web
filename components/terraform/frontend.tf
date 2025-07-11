variable "frontend_instance_type" {}
variable "frontend_key_name" {}
variable "frontend_root_block_device_size" {}

variable "frontend_asg_max_size" {}
variable "frontend_asg_min_size" {}
variable "frontend_asg_desired_capacity" {}
variable "frontend_asg_health_check_grace_period" {}
variable "frontend_asg_health_check_type" {}

variable "frontend_auto_switch_off" {}
variable "frontend_auto_switch_on" {}
variable "frontend_deployment_group" {}
variable "frontend_patch_group" {}
variable "frontend_deployment_s3_bucket" {}
variable "frontend_folder_s3_key" {}


module "frontend" {
    source = "./frontend"

    environment = var.environment
    ami_id = data.aws_ami.frontend_ami.id

    route53_zone = data.aws_ssm_parameter.zone_id.value

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    asg_max_size = var.frontend_asg_max_size
    asg_min_size = var.frontend_asg_min_size
    asg_desired_capacity = var.frontend_asg_desired_capacity
    asg_health_check_grace_period = var.frontend_asg_health_check_grace_period
    asg_health_check_type = var.frontend_asg_health_check_type

    instance_type = var.frontend_instance_type
    key_name = "web-frontend-${var.environment}-eu-west-2"
    root_block_device_size = "100"

    instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]
    lb_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]
    

    auto_switch_off = var.frontend_auto_switch_off
    auto_switch_on = var.frontend_auto_switch_on
    deployment_group = var.frontend_deployment_group
    patch_group = var.frontend_patch_group

    deployment_s3_bucket = var.frontend_deployment_s3_bucket
    folder_s3_key = var.frontend_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
