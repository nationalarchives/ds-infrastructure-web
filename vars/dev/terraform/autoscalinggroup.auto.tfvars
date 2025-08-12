frontend_patch_group      = "frontend-patchgroup"
frontend_deployment_group = "frontend-deploygroup"

frontend_asg_max_size                  = 2
frontend_asg_min_size                  = 1
frontend_asg_desired_capacity          = 1
frontend_asg_health_check_grace_period = 150
frontend_asg_health_check_type         = "EC2"


rp_nginx_patch_group      = "web-rp-patchgroup"
rp_nginx_deployment_group = "web-rp-deploygroup"

rp_asg_max_size                  = 2
rp_asg_min_size                  = 1
rp_asg_desired_capacity          = 1
rp_asg_health_check_grace_period = 150
rp_asg_health_check_type         = "EC2"

wagtail_patch_group      = "wagtail-patchgroup"
wagtail_deployment_group = "wagtail-deploygroup"

wagtail_asg_max_size                  = 2
wagtail_asg_min_size                  = 1
wagtail_asg_desired_capacity          = 1
wagtail_asg_health_check_grace_period = 150
wagtail_asg_health_check_type         = "EC2"

enrichment_patch_group      = "enrichment-patchgroup"
enrichment_deployment_group = "enrichment-deploygroup"

enrichment_asg_max_size                  = 2
enrichment_asg_min_size                  = 1
enrichment_asg_desired_capacity          = 1
enrichment_asg_health_check_grace_period = 150
enrichment_asg_health_check_type         = "EC2"


redis_patch_group      = "redis-patchgroup"
redis_deployment_group = "redis-deploygroup"

redis_asg_max_size                  = 2
redis_asg_min_size                  = 1
redis_asg_desired_capacity          = 1
redis_asg_health_check_grace_period = 150
redis_asg_health_check_type         = "EC2"


catalogue_patch_group      = "catalogue-patchgroup"
catalogue_deployment_group = "catalogue-deploygroup"

catalogue_asg_max_size                  = 2
catalogue_asg_min_size                  = 1
catalogue_asg_desired_capacity          = 1
catalogue_asg_health_check_grace_period = 150
catalogue_asg_health_check_type         = "EC2"


search_patch_group      = "search-patchgroup"
search_deployment_group = "search-deploygroup"

search_asg_max_size                  = 2
search_asg_min_size                  = 1
search_asg_desired_capacity          = 1
search_asg_health_check_grace_period = 150
search_asg_health_check_type         = "EC2"