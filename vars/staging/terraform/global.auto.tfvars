## -----------------------------------------------------------------------------
## Environment Specific Variables

account = "staging"
environment = "staging"
region      = "eu-west-2"
service     = "web-frontend"

internal_domain_name = "web-frontend.staging.local"

deployment_s3_bucket  = "ds-staging-deployment-source"
logfile_s3_bucket     = "ds-staging-logfiles"
s3_deployment_rp_nginx_runtime_key = "staging"

frontend_deployment_s3_root = "web/frontend"
frontend_logfile_s3_root    = "web/frontend"

enrichment_deployment_s3_root = "web/enrichment"
enrichment_logfile_s3_root = "web/enrichment"

rp_deployment_s3_root = "web/reverse-proxy"
rp_logfile_s3_root    = "web/reverse-proxy"

on_prem_cidrs = [
    "172.31.2.0/24",
    "172.31.6.0/24",
    "172.31.10.0/24"
]

## Route53 Variables
route53_zone = "Z01866642Z55TMPV5WNYZ"
