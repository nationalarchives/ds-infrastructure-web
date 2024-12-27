resource "aws_autoscaling_group" "web_frontend" {
    name = "web-frontend"
    launch_template {
        id      = aws_launch_template.web_frontend.id
        version = aws_launch_template.web_frontend.latest_version
    }

    vpc_zone_identifier = [
        var.private_subnet_a_id,
        var.private_subnet_b_id
    ]

    max_size                  = var.asg_max_size
    min_size                  = var.asg_min_size
    desired_capacity          = var.asg_desired_capacity
    health_check_grace_period = var.asg_health_check_grace_period
    health_check_type         = var.asg_health_check_type

    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]

    metrics_granularity = "1Minute"

    lifecycle {
        create_before_destroy = true
        ignore_changes = [
            load_balancers,
            target_group_arns
        ]
    }

    tag = merge(var.asg_tags, [
        {
            key                 = "Name"
            propagate_at_launch = true
            value               = "web-frontend"
        },
        {
            key                 = "AutoSwitchOff"
            value               = var.auto_switch_off
            propagate_at_launch = "true"
        },
        {
            key                 = "AutoSwitchOn"
            value               = var.auto_switch_on
            propagate_at_launch = "true"
        },
        {
            key                 = "PatchGroup"
            value               = var.patch_group
            propagate_at_launch = "true"
        },
        {
            key                 = "DeploymentGroup"
            value               = var.deployment_group
            propagate_at_launch = "true"
        },
    ])
}

resource "aws_autoscaling_attachment" "web_frontend" {
    autoscaling_group_name = aws_autoscaling_group.web_frontend.id
    lb_target_group_arn    = aws_lb_target_group.web_frontend.arn
}

resource "aws_autoscaling_policy" "web_frontend_up_policy" {
    name                   = "web-frontend-up-policy"
    scaling_adjustment     = 1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.web_frontend.name
}

resource "aws_autoscaling_policy" "web_frontend_down_policy" {
    name                   = "web-frontend-down-policy"
    scaling_adjustment     = -1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = aws_autoscaling_group.web_frontend.name
}
