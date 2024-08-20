terraform {
    required_version = ">= 1.9.4"

    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    alias  = "aws-cf-waf"
    region = "us-east-1"
}

provider "aws" {
    region = "eu-west-2"
    alias  = "environment"
}

# this provider is used for command line to  suppress input for region
provider "aws" {
    region = "eu-west-2"
}
