## -----------------------------------------------------------------------------
## locals

locals {
    tags = {
        Terraform   = "true"
        Product     = "web"
        Environment = var.account
        CostCentre  = "53"
        Owner       = "Digital Services"
        Region      = "eu-west-2"
    }

    asg_default_tags = [
        {
            key                 = "Service"
            value               = "web"
            propagate_at_launch = "true"
        },
        {
            key                 = "Owner"
            value               = "Digital Services"
            propagate_at_launch = "true"
        },
        {
            key                 = "CostCentre"
            value               = 53
            propagate_at_launch = "true"
        },
        {
            key                 = "Terraform"
            value               = "true"
            propagate_at_launch = "true"
        },
        {
            key                 = "PatchGroup"
            value               = var.frontend_patch_group
            propagate_at_launch = "true"
        },
        {
            key                 = "Deployment-Group"
            value               = var.frontend_deployment_group
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
