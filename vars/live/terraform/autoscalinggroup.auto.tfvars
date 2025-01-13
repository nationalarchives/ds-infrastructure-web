frontend_patch_group      = "frontend-patchgroup"
frontend_deployment_group = "frontend-deploygroup"

frontend_asg_max_size                  = 2
frontend_asg_min_size                  = 1
frontend_asg_desired_capacity          = 1
frontend_asg_health_check_grace_period = 150
frontend_asg_health_check_type         = "EC2"
