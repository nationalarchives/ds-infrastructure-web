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