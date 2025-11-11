variable "enrichment_instance_type" {}
variable "enrichment_key_name" {}
variable "enrichment_root_block_device_size" {}

variable "enrichment_asg_max_size" {}
variable "enrichment_asg_min_size" {}
variable "enrichment_asg_desired_capacity" {}
variable "enrichment_asg_health_check_grace_period" {}
variable "enrichment_asg_health_check_type" {}

variable "enrichment_auto_switch_off" {}
variable "enrichment_auto_switch_on" {}
variable "enrichment_deployment_group" {}
variable "enrichment_patch_group" {}
variable "enrichment_deployment_s3_bucket" {}
variable "enrichment_folder_s3_key" {}

module "enrichment" {
    source = "./enrichment"

    ami_id = data.aws_ami.enrichment_ami.id

    lb_listener_arn = module.load-balancer.lb_listener_arn
    x_target_header = "web-enrichment"
    host_header = "web-enrichment.${var.environment}.local"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    enrichment_sg_id = module.sgs.enrichment_sg_id

    asg_max_size = var.enrichment_asg_max_size
    asg_min_size = var.enrichment_asg_min_size
    asg_desired_capacity = var.enrichment_asg_desired_capacity
    asg_health_check_grace_period = var.enrichment_asg_health_check_grace_period
    asg_health_check_type = var.enrichment_asg_health_check_type

    instance_type = var.enrichment_instance_type
    key_name = "web-enrichment-${var.environment}-eu-west-2"
    root_block_device_size = "100"

    auto_switch_off = var.enrichment_auto_switch_off
    auto_switch_on = var.enrichment_auto_switch_on
    deployment_group = var.enrichment_deployment_group
    patch_group = var.enrichment_patch_group

    deployment_s3_bucket = var.enrichment_deployment_s3_bucket
    folder_s3_key = var.enrichment_folder_s3_key

    asg_tags = local.asg_default_tags
    tags = local.tags
}
