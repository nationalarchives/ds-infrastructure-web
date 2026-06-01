variable "web_hosprec_instance_type" {}
variable "web_hosprec_key_name" {}
variable "web_hosprec_root_block_device_size" {}
variable "web_hosprec_asg_max_size" {}
variable "web_hosprec_asg_min_size" {}
variable "web_hosprec_asg_desired_capacity" {}
variable "web_hosprec_asg_health_check_grace_period" {}
variable "web_hosprec_asg_health_check_type" {}

variable "web_hosprec_auto_switch_off" {}
variable "web_hosprec_auto_switch_on" {}
variable "web_hosprec_deployment_group" {}
variable "web_hosprec_patch_group" {}
variable "web_hosprec_deployment_s3_bucket" {}
variable "web_hosprec_folder_s3_key" {}

module "web_hosprec" {
    source = "./web-hosprec"

    ami_id = data.aws_ami.web_hosprec_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "web-hosprec"
    host_header = "web-hosprec.${var.environment}.local"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    web_hosprec_sg_id = module.sgs.web_hosprec_sg_id
    efs_dns_name = module.media_efs.media_efs_dns_name
    enable_monitoring = var.enable_monitoring
    
    asg_max_size = var.web_hosprec_asg_max_size
    asg_min_size = var.web_hosprec_asg_min_size
    asg_desired_capacity = var.web_hosprec_asg_desired_capacity
    asg_health_check_grace_period = var.web_hosprec_asg_health_check_grace_period
    asg_health_check_type = var.web_hosprec_asg_health_check_type

    instance_type = var.web_hosprec_instance_type
    key_name = "web-frontend-${var.environment}-eu-west-2"
    root_block_device_size = "100"

    auto_switch_off = var.web_hosprec_auto_switch_off
    auto_switch_on = var.web_hosprec_auto_switch_on
    deployment_group = var.web_hosprec_deployment_group
    patch_group = var.web_hosprec_patch_group

    deployment_s3_bucket = var.web_hosprec_deployment_s3_bucket
    folder_s3_key = var.web_hosprec_folder_s3_key
    asg_tags = local.asg_default_tags
    tags = local.tags
}
