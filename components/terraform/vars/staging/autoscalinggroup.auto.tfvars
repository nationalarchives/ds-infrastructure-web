# Frontend
frontend_patch_group      = "frontend-patchgroup"
frontend_deployment_group = "frontend-deploygroup"

enable_autoscaling = false
frontend_asg_max_size                  = 2
frontend_asg_min_size                  = 1
frontend_asg_desired_capacity          = 1
frontend_asg_health_check_grace_period = 150
frontend_asg_health_check_type         = "EC2"
frontend_autoscaling_policy_name_prefix = ""  
frontend_default_cooldown               = 0   
frontend_scale_in_threshold             = 0  
frontend_scale_out_threshold            = 0  

# Wagtail
wagtail_patch_group      = "wagtail-patchgroup"
wagtail_deployment_group = "wagtail-deploygroup"

wagtail_asg_max_size                  = 2
wagtail_asg_min_size                  = 1
wagtail_asg_desired_capacity          = 1
wagtail_asg_health_check_grace_period = 150
wagtail_asg_health_check_type         = "EC2"
wagtail_autoscaling_policy_name_prefix = ""  
wagtail_default_cooldown               = 0   
wagtail_scale_in_threshold             = 0  
wagtail_scale_out_threshold            = 0

# Enrichment
enrichment_patch_group      = "enrichment-patchgroup"
enrichment_deployment_group = "enrichment-deploygroup"

enrichment_asg_max_size                  = 2
enrichment_asg_min_size                  = 1
enrichment_asg_desired_capacity          = 1
enrichment_asg_health_check_grace_period = 150
enrichment_asg_health_check_type         = "EC2"

# Redis
redis_patch_group      = "redis-patchgroup"
redis_deployment_group = "redis-deploygroup"

redis_asg_max_size                  = 2
redis_asg_min_size                  = 1
redis_asg_desired_capacity          = 1
redis_asg_health_check_grace_period = 150
redis_asg_health_check_type         = "EC2"

# Catalogue
catalogue_patch_group      = "catalogue-patchgroup"
catalogue_deployment_group = "catalogue-deploygroup"

catalogue_asg_max_size                  = 2
catalogue_asg_min_size                  = 1
catalogue_asg_desired_capacity          = 1
catalogue_asg_health_check_grace_period = 150
catalogue_asg_health_check_type         = "EC2"
catalogue_autoscaling_policy_name_prefix = ""  
catalogue_default_cooldown               = 0   
catalogue_scale_in_threshold             = 0  
catalogue_scale_out_threshold            = 0

# Search
search_patch_group      = "search-patchgroup"
search_deployment_group = "search-deploygroup"

search_asg_max_size                  = 2
search_asg_min_size                  = 1
search_asg_desired_capacity          = 1
search_asg_health_check_grace_period = 150
search_asg_health_check_type         = "EC2"

# Wagtail Docs
wagtaildocs_patch_group      = "wagtaildocs-patchgroup"
wagtaildocs_deployment_group = "wagtaildocs-deploygroup"

wagtaildocs_asg_max_size                  = 2
wagtaildocs_asg_min_size                  = 1
wagtaildocs_asg_desired_capacity          = 1
wagtaildocs_asg_health_check_grace_period = 150
wagtaildocs_asg_health_check_type         = "EC2"

# Request Service Record
request_service_record_patch_group      = "request-service-record-patchgroup"
request_service_record_deployment_group = "request-service-record-deploygroup"

request_service_record_asg_max_size                  = 2
request_service_record_asg_min_size                  = 1
request_service_record_asg_desired_capacity          = 1
request_service_record_asg_health_check_grace_period = 150
request_service_record_asg_health_check_type         = "EC2"
