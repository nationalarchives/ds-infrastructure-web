variable "redis_instance_type" {}
variable "redis_key_name" {}
variable "redis_root_block_device_size" {}

variable "redis_asg_max_size" {}
variable "redis_asg_min_size" {}
variable "redis_asg_desired_capacity" {}
variable "redis_asg_health_check_grace_period" {}
variable "redis_asg_health_check_type" {}

variable "redis_auto_switch_off" {}
variable "redis_auto_switch_on" {}
variable "redis_deployment_group" {}
variable "redis_patch_group" {}
variable "redis_deployment_s3_bucket" {}
variable "redis_folder_s3_key" {}

module "redis" {
    source = "./redis"

    environment = var.environment
    ami_id = data.aws_ami.redis_ami.id

    route53_zone = data.aws_ssm_parameter.zone_id.value

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value
    
    
    
    redis_sg_id = module.sgs.redis_sg_id
    redis_lb_id = module.sgs.redis_lb_id
    
    asg_max_size = var.redis_asg_max_size
    asg_min_size = var.redis_asg_min_size
    asg_desired_capacity = var.redis_asg_desired_capacity
    asg_health_check_grace_period = var.redis_asg_health_check_grace_period
    asg_health_check_type = var.redis_asg_health_check_type

    instance_type = var.redis_instance_type
    key_name = "wagtail-redis-${var.environment}-eu-west-2"
    root_block_device_size = "100"

    instance_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]
    lb_cidr = [
        data.aws_ssm_parameter.private_subnet_2a_cidr.value,
        data.aws_ssm_parameter.private_subnet_2b_cidr.value,
    ]
    

    auto_switch_off = var.redis_auto_switch_off
    auto_switch_on = var.redis_auto_switch_on
    deployment_group = var.redis_deployment_group
    patch_group = var.redis_patch_group

    deployment_s3_bucket = var.redis_deployment_s3_bucket
    folder_s3_key = var.redis_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
