variable "frontend_asg_min_size" {}
variable "frontend_asg_max_size" {}
variable "frontend_asg_desired_capacity" {}
variable "frontend_asg_health_check_grace_period" {}
variable "frontend_asg_health_check_type" {}

variable "frontend_key_name" {}
variable "frontend_instance_type" {}

variable "frontend_patch_group" {}
variable "frontend_deployment_group" {}

variable "frontend_root_block_device_size" {}

variable "frontend_auto_switch_on" {
    default = true
}
variable "frontend_auto_switch_off" {
    default = true
}


module "frontend" {
    source = "./frontend"

    vpc_id              = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    lb_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]

    instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_db_subnet_2b_cidr.value,
        data.aws_ssm_parameter.client_vpn_cidr.value,
    ]


    ami_id        = data.aws_ami.frontend_ami.id
    key_name      = var.frontend_key_name
    instance_type = var.frontend_instance_type

    deployment_s3_bucket = "ds-${var.account}-deployment-source"
    folder_s3_key = "web"

    # autoscaling
    asg_min_size                  = var.frontend_asg_min_size
    asg_max_size                  = var.frontend_asg_max_size
    asg_desired_capacity          = var.frontend_asg_desired_capacity
    asg_health_check_type         = var.frontend_asg_health_check_type            
    asg_health_check_grace_period = var.frontend_asg_health_check_grace_period

    patch_group      = var.frontend_patch_group
    deployment_group = var.frontend_deployment_group

    root_block_device_size = var.frontend_root_block_device_size

    auto_switch_off = var.frontend_auto_switch_off
    auto_switch_on  = var.frontend_auto_switch_on

    asg_tags = local.asg_default_tags
    tags = local.tags
}
