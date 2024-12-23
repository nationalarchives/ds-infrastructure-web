terraform {
    backend "s3" {
        bucket = "ds-terraform-state-eu-west-2-846769538626"      # No changes required as we use same bucket
        key    = "ds-infrastructure-web/terraform.tfstate"      # changed beta to web
        region = "eu-west-2"
    }
}
