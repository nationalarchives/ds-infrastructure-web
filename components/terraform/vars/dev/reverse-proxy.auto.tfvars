web_reverse_proxy_folder_s3_key = "nginx"
web_reverse_proxy_deployment_s3_bucket = "ds-dev-deployment-source"
web_reverse_proxy_instance_type = "t3a.small"
web_reverse_proxy_key_name      = "web-frontend-dev-eu-west-2"

web_reverse_proxy_root_block_device_size = "40"

web_reverse_proxy_auto_switch_on   = true
web_reverse_proxy_auto_switch_off  = true
resolver    = "10.128.208.2"
vpc_cidr    = "10.128.208.0/21"

nginx_folder_s3_key = "nginx"
efs_mount_dir = "/mnt/efs"
