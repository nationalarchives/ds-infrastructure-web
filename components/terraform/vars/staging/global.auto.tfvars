## -----------------------------------------------------------------------------
## Environment Specific Variables

account = "staging"
environment = "staging"
region      = "eu-west-2"
service     = "web-frontend"

internal_domain_name = "web-frontend.staging.local"

deployment_s3_bucket  = "ds-staging-deployment-source"
logfile_s3_bucket     = "ds-staging-logfiles"


web_frontend_deployment_s3_root = "web/frontend"
web_frontend_logfile_s3_root    = "web/frontend"

web_enrichment_deployment_s3_root = "web/enrichment"
web_enrichment_logfile_s3_root = "web/enrichment"


on_prem_cidrs = [
    "172.31.2.0/24",
    "172.31.6.0/24",
    "172.31.10.0/24"
]

## Route53 Variables
route53_zone = "Z01866642Z55TMPV5WNYZ"
