## -----------------------------------------------------------------------------
## Environment Specific Variables

account = "live"
environment = "live"
region      = "eu-west-2"
service     = "web-frontend"

internal_domain_name = "web-frontend.live.local"

deployment_s3_bucket  = "ds-live-deployment-source"
logfile_s3_bucket     = "ds-live-logfiles"

web_enrichment_deployment_s3_root = "web/enrichment"
web_enrichment_logfile_s3_root = "web/enrichment"

web_frontend_deployment_s3_root = "web/frontend"
web_frontend_logfile_s3_root    = "web/frontend"

enable_monitoring                 = true
slack_workspace_id = "T09LRLGHY"
slack_channel_id   = "C0A7BDN600K"


on_prem_cidrs = [
    "172.31.2.0/24",
    "172.31.6.0/24",
    "172.31.10.0/24"
]


## Route53 Variables
route53_zone = "Z0908079JT6PK81GYP0V"
