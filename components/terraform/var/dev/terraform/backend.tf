terraform {
    backend "s3" {
        bucket = "ds-terraform-state-eu-west-2-846769538626"
        key    = "ds-infrastructure-beta/terraform.tfstate"
        region = "eu-west-2"
    }
}
