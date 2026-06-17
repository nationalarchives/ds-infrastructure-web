locals {
    # s3 deloyment source access policy - s3_deployment_source_access_policy
    object_arns = [
        "${var.s3_deployment_source_arn.value}/web/*",
    ]
}
