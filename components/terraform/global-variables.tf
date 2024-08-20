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
}
