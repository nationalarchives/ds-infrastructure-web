deployment_configs = {
    "wordpress" = {
        "minimum_healthy_hosts" = [
            {
                "type"  = "HOST_COUNT"
                "value" = "1"
            }
        ]
        "traffic_routing_config" = []
    }
    "web_reverse_proxy" = {
        "minimum_healthy_hosts" = [
            {
                "type"  = "HOST_COUNT"
                "value" = "0"
            }
        ]
        "traffic_routing_config" = []
    }
}

rollback_configs = {
    "wordpress" = {
        "alarm_conf" = [
            {
                alarms                    = ["web-wp-deployment"]
                enabled                   = true
                ignore_poll_alarm_failure = false
            }
        ]
        "rollback_conf" = [
            {
                enabled = true
                events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
            }
        ]
        "blue_green_conf" = [
            {
                deployment_ready_option = {
                    action_on_timeout    = "CONTINUE_DEPLOYMENT"
                    wait_time_in_minutes = null
                }
                "green_fleet_povisioning_option" = {
                    action = "DISCOVER_EXISTING"
                }
                "terminate_blue_instances_on_deployment_success" = {
                    action                           = "TERMINATE"
                    termination_wait_time_in_minutes = 1
                }
            }
        ]
        "deployment_style" = [
            {
                deployment_option = "WITHOUT_TRAFFIC_CONTROL"
                deployment_type   = "IN_PLACE"

            }
        ]
        "ec2_tag_filters" = [
            {
                key   = "Deployment-Group"
                type  = "KEY_AND_VALUE"
                value = "web-wp"
            }
        ]
    }
    "web_reverse_proxy" = {
        "alarm_conf" = [
            {
                alarms                    = ["web-reverse-proxy-deployment"]
                enabled                   = true
                ignore_poll_alarm_failure = false
            }
        ]
        "rollback_conf" = [
            {
                enabled = true
                events  = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
            }
        ]
        "blue_green_conf" = [
            {
                deployment_ready_option = {
                    action_on_timeout    = "CONTINUE_DEPLOYMENT"
                    wait_time_in_minutes = null
                }
                "green_fleet_povisioning_option" = {
                    action = "DISCOVER_EXISTING"
                }
                "terminate_blue_instances_on_deployment_success" = {
                    action                           = "TERMINATE"
                    termination_wait_time_in_minutes = 1
                }
            }
        ]
        "deployment_style" = [
            {
                deployment_option = "WITHOUT_TRAFFIC_CONTROL"
                deployment_type   = "IN_PLACE"

            }
        ]
        "ec2_tag_filters" = [
            {
                key   = "Deployment-Group"
                type  = "KEY_AND_VALUE"
                value = "web-nginx-rp"
            }
        ]
    }
}
