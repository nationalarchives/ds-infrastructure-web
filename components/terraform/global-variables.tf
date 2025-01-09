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
        },
        {
            key                 = "Owner"
            value               = "Digital Services"
        },
        {
            key                 = "CostCentre"
            value               = 53
        },
        {
            key                 = "Terraform"
            value               = "true"
        },
    ]
}

variable "environment" {}
