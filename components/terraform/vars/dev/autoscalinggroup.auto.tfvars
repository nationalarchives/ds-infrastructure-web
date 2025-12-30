# Frontend
web_frontend_patch_group      = "web-frontend-patchgroup"
web_frontend_deployment_group = "web-frontend-deploygroup"

enable_autoscaling                     = false
web_frontend_asg_max_size                  = 2
web_frontend_asg_min_size                  = 1
web_frontend_asg_desired_capacity          = 1
web_frontend_asg_health_check_grace_period = 150
web_frontend_asg_health_check_type         = "EC2"
web_frontend_autoscaling_policy_name_prefix = ""  
web_frontend_default_cooldown               = 0   
web_frontend_scale_in_threshold             = 0  
web_frontend_scale_out_threshold            = 0   

# Wagtail
web_wagtail_patch_group      = "web-wagtail-patchgroup"
web_wagtail_deployment_group = "web-wagtail-deploygroup"

web_wagtail_asg_max_size                  = 2
web_wagtail_asg_min_size                  = 1
web_wagtail_asg_desired_capacity          = 1
web_wagtail_asg_health_check_grace_period = 150
web_wagtail_asg_health_check_type         = "EC2"
web_wagtail_autoscaling_policy_name_prefix = ""  
web_wagtail_default_cooldown               = 0   
web_wagtail_scale_in_threshold             = 0  
web_wagtail_scale_out_threshold            = 0   

# Web Enrichment
web_enrichment_patch_group      = "web-enrichment-patchgroup"
web_enrichment_deployment_group = "web-enrichment-deploygroup"

web_enrichment_asg_max_size                  = 2
web_enrichment_asg_min_size                  = 1
web_enrichment_asg_desired_capacity          = 1
web_enrichment_asg_health_check_grace_period = 150
web_enrichment_asg_health_check_type         = "EC2"

# Redis
redis_patch_group      = "redis-patchgroup"
redis_deployment_group = "redis-deploygroup"

redis_asg_max_size                  = 2
redis_asg_min_size                  = 1
redis_asg_desired_capacity          = 1
redis_asg_health_check_grace_period = 150
redis_asg_health_check_type         = "EC2"

# Catalogue
web_catalogue_patch_group      = "web-catalogue-patchgroup"
web_catalogue_deployment_group = "web-catalogue-deploygroup"

web_catalogue_asg_max_size                  = 2
web_catalogue_asg_min_size                  = 1
web_catalogue_asg_desired_capacity          = 1
web_catalogue_asg_health_check_grace_period = 150
web_catalogue_asg_health_check_type         = "EC2"
web_catalogue_autoscaling_policy_name_prefix = ""  
web_catalogue_default_cooldown               = 0   
web_catalogue_scale_in_threshold             = 0  
web_catalogue_scale_out_threshold            = 0

# Search
web_search_patch_group      = "web-search-patchgroup"
web_search_deployment_group = "web-search-deploygroup"

web_search_asg_max_size                  = 2
web_search_asg_min_size                  = 1
web_search_asg_desired_capacity          = 1
web_search_asg_health_check_grace_period = 150
web_search_asg_health_check_type         = "EC2"

# Wagtail Docs
web_wagtaildocs_patch_group      = "web-wagtaildocs-patchgroup"
web_wagtaildocs_deployment_group = "web-wagtaildocs-deploygroup"

web_wagtaildocs_asg_max_size                  = 2
web_wagtaildocs_asg_min_size                  = 1
web_wagtaildocs_asg_desired_capacity          = 1
web_wagtaildocs_asg_health_check_grace_period = 150
web_wagtaildocs_asg_health_check_type         = "EC2"

# Web Request Service Record
web_request_service_record_patch_group      = "web-request-service-record-patchgroup"
web_request_service_record_deployment_group = "web-request-service-record-deploygroup"

web_request_service_record_asg_max_size                  = 2
web_request_service_record_asg_min_size                  = 1
web_request_service_record_asg_desired_capacity          = 1
web_request_service_record_asg_health_check_grace_period = 150
web_request_service_record_asg_health_check_type         = "EC2"