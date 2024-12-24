locals {
    dw_asg_tags = [
        {
            key                 = "Name"
            value               = "web-dw"
            propagate_at_launch = "true"
        },
        {
            key                 = "Service"
            value               = "web"
            propagate_at_launch = "true"
        },
        {
            key                 = "Owner"
            value               = local.tags.Owner
            propagate_at_launch = "true"
        },
        {
            key                 = "CostCentre"
            value               = local.tags.CostCentre
            propagate_at_launch = "true"
        },
        {
            key                 = "Terraform"
            value               = "true"
            propagate_at_launch = "true"
        },
        {
            key                 = "PatchGroup"
            value               = var.dw_patch_group
            propagate_at_launch = "true"
        },
        {
            key                 = "Deployment-Group"
            value               = var.dw_deployment_group
            propagate_at_launch = "true"
        },
        {
            key                 = "AutoSwitchOn"
            value               = "true"
            propagate_at_launch = "true"
        },
        {
            key                 = "AutoSwitchOff"
            value               = "true"
            propagate_at_launch = "true"
        },
    ]

}

variable "dw_key_name" {}
variable "dw_instance_type" {}
variable "dw_root_block_device_size" {}

variable "dw_efs_mount_dir" {}

variable "dw_patch_group" {}
variable "dw_deployment_group" {}
variable "dw_auto_switch_on" {}
variable "dw_auto_switch_off" {}

variable "dw_asg_max_size" {}
variable "dw_asg_min_size" {}
variable "dw_asg_desired_capacity" {}
variable "dw_asg_health_check_grace_period" {}
variable "dw_asg_health_check_type" {}

module "django-wagtail" {
    source = "./django-wagtail"

    vpc_id              = data.aws_ssm_parameter.vpc_id.value
    private_subnet_a_id = data.aws_ssm_parameter.private_subnet_2a_id.value
    private_subnet_b_id = data.aws_ssm_parameter.private_subnet_2b_id.value

    lb_sg_id = module.sgs.dw_lb_sg_id         #check later

    efs_id = module.sgs.upload_efs_sg_id        #check later

    ami_id                 = data.aws_ami.web_dw_ami.id
    instance_type          = var.dw_instance_type
    instance_profile_arn   = module.roles.dw_profile_arn      #check later    #check later
    key_name               = var.dw_key_name
    root_block_device_size = var.dw_root_block_device_size
     #check later
    sg_ids                  = [                                #check later
        module.sgs.dw_sg_id,
        module.sgs.ec2_mount_efs_sg_id,
    ]

    efs_mount_dir = var.dw_efs_mount_dir                    
    efs_dns_name  = module.efs.media_efs_dns_name          #check later

    patch_group      = var.dw_patch_group
    deployment_group = var.dw_deployment_group
    auto_switch_on   = var.dw_auto_switch_on
    auto_switch_off  = var.dw_auto_switch_off

    asg_min_size                  = var.dw_asg_min_size
    asg_max_size                  = var.dw_asg_max_size
    asg_desired_capacity          = var.dw_asg_desired_capacity
    asg_health_check_grace_period = var.dw_asg_health_check_grace_period
    asg_health_check_type         = var.dw_asg_health_check_type

    deployment_s3_bucket = var.deployment_s3_bucket
    folder_s3_key        = var.logfile_s3_bucket

    asg_tags = local.dw_asg_tags

    tags = local.tags
}
