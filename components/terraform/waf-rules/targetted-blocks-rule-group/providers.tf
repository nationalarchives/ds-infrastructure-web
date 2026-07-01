# ===================================================================================================================
# Declare aliased providers
# ===================================================================================================================
terraform {
    required_version = ">= 1.14.8"

    required_providers {
        aws = {
            version = ">= 6.41.0"
            source  = "hashicorp/aws"
            configuration_aliases = [
                aws.aws-cf-waf
            ]
        }
    }
}
