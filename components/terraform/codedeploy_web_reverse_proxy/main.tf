resource "aws_codedeploy_deployment_config" "config" {
    deployment_config_name = var.deployment_config_name
    compute_platform       = "Server"

    dynamic "minimum_healthy_hosts" {
        for_each = var.minimum_healthy_hosts
        iterator = min_hosts
        content {
            type  = min_hosts.value.type
            value = min_hosts.value.value
        }
    }

    dynamic "traffic_routing_config" {
        for_each = var.traffic_routing_config
        iterator = route_config
        content {
            type = route_config.value.type
            dynamic time_based_canary {
                for_each = route_config.value.time_based_canary
                iterator = canary
                content {
                    interval   = canary.value.interval
                    percentage = canary.value.percentage
                }
            }
            dynamic time_based_linear {
                for_each = route_config.value.time_based_linear
                iterator = linear
                content {
                    interval   = linear.value.interval
                    percentage = linear.value.percentage
                }
            }
        }
    }
}

resource "aws_codedeploy_deployment_group" "web_reverse_proxy" {
    depends_on = [
        aws_codedeploy_deployment_config.config
    ]

    app_name               = aws_codedeploy_app.web_reverse_proxy.name
    deployment_group_name  = var.deployment_group_name
    service_role_arn       = var.service_role_arn
    deployment_config_name = aws_codedeploy_deployment_config.config.id

    dynamic "auto_rollback_configuration" {
        for_each = var.auto_rollback_configuration
        iterator = rollback
        content {
            enabled = rollback.value.enabled
            events  = rollback.value.events
        }
    }

    dynamic "alarm_configuration" {
        for_each = var.alarm_configuration
        iterator = alarm_conf
        content {
            alarms                    = alarm_conf.value.alarms
            enabled                   = alarm_conf.value.enabled
            ignore_poll_alarm_failure = alarm_conf.value.ignore_poll_alarm_failure
        }
    }

    dynamic "blue_green_deployment_config" {
        for_each = var.blue_green_deployment_config
        iterator = blue_green
        content {
            deployment_ready_option {
                action_on_timeout    = blue_green.value.deployment_ready_option.action_on_timeout
                wait_time_in_minutes = blue_green.value.deployment_ready_option.wait_time_in_minutes
            }
            green_fleet_provisioning_option {
                action = blue_green.value.green_fleet_povisioning_option.action
            }
            terminate_blue_instances_on_deployment_success {
                action                           = blue_green.value.terminate_blue_instances_on_deployment_success.action
                termination_wait_time_in_minutes = blue_green.value.terminate_blue_instances_on_deployment_success.termination_wait_time_in_minutes
            }
        }
    }

    dynamic "deployment_style" {
        for_each = var.deployment_style
        iterator = style
        content {
            deployment_option = style.value.deployment_option
            deployment_type   = style.value.deployment_type
        }
    }

    ec2_tag_set {
        dynamic "ec2_tag_filter" {
            for_each = var.ec2_tag_filters
            iterator = filter
            content {
                key   = filter.value.key
                type  = filter.value.type
                value = filter.value.value
            }
        }
    }
}

resource "aws_codedeploy_app" "web_reverse_proxy" {
    compute_platform = "Server"
    name             = var.app_name

    tags = {
        Name       = "${var.app_name}-cd",
        CostCentre = "53",
        CreatedBy  = "Digital Services"
        Terrafrom  = "true"
    }
}
