#--------------------------------------------------------------
################ Roles #############################
#--------------------------------------------------------------

data "aws_caller_identity" "current" {}

# Frontend Role
resource "aws_iam_role" "web_frontend_role" {
  name               = "web-frontend-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# wagtail Role
resource "aws_iam_role" "web_wagtail_role" {
  name               = "web-wagtail-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Catalogue Role
resource "aws_iam_role" "web_catalogue_role" {
  name               = "web-catalogue-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Search Role
resource "aws_iam_role" "web_search_role" {
  name               = "web-search-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Web Enrichment Role
resource "aws_iam_role" "web_enrichment_role" {
  name               = "web-enrichment-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# wagtaildocs Role
resource "aws_iam_role" "web_wagtaildocs_role" {
  name               = "web-wagtaildocs-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Forms Role
resource "aws_iam_role" "web_forms_role" {
  name               = "web-forms-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# HoSPREC Role
resource "aws_iam_role" "web_hosprec_role" {
  name               = "web-hosprec-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Web Reverse Proxy Role
resource "aws_iam_role" "web_reverse_proxy_role" {
    name = "web-reverse-proxy-assume-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Web Bulkdownload Role
resource "aws_iam_role" "web_bulkdownload_role" {
    name = "web-bulkdownload-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Request Service Record Role - MoD FoI
resource "aws_iam_role" "web_request_service_record_role" {
  name = "web-request-service-record-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Lambda Web Request Service Record Role - MoD FoI
resource "aws_iam_role" "lambda_web_request_service_record_role" {
  name               = "lambda-web-request-service-record-role"
  assume_role_policy = file("${path.root}/shared-templates/assume-role-lambda-policy.json")
  description        = "Allow Lambda to process S3 and SQS events"
  tags               = var.tags
}

# Lambda AutoRunStartupScript Role
resource "aws_iam_role" "lambda_auto_run_startup_script_role" {
  name               = "LambdaSSMExecutionRole"
  assume_role_policy = file("${path.root}/shared-templates/assume-role-lambda-policy.json")
  description        = "allow lambda to call script on instances"
  tags               = var.tags
}

# Lambda WagtailCronTrigger Role
resource "aws_iam_role" "lambda_wagtail_cron_trigger_role" {
  name               = "WagtailLambdaExecutionRole"
  assume_role_policy = file("${path.root}/shared-templates/assume-role-lambda-policy.json")
  description        = "Allows Lambda functions to call AWS services on your behalf"
  tags               = var.tags
}

# Web RSR Role - MoD FoI
resource "aws_iam_role" "lambda_web_rsr_cron_role" {
  name               = "WebrsrCronRole"
  assume_role_policy = file("${path.root}/shared-templates/assume-role-lambda-policy.json")
  description        = "Allows Lambda functions to call AWS services on your behalf"
  tags               = var.tags
}
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_web_rsr_cron_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# CodeDeploy Service Role for Web Role
resource "aws_iam_role" "codedeploy_web_reverse_proxy_service_role" {
    name = "codedeploy-web-reverse-proxy-service_role"
    assume_role_policy = file("${path.root}/shared-templates/codedeploy-service-policy.json")
    tags = var.tags
}

# CodeDeploy Service Role for Web Role
resource "aws_iam_role" "codedeploy_web_service_role" {
    name = "codedeploy-web-service_role"
    assume_role_policy = file("${path.root}/shared-templates/codedeploy-service-policy.json")
    tags = var.tags
}

resource "aws_iam_role" "web_lambda_sync_s3_to_efs" {
    name = "web-lambda-sync-s3-to-efs"
    assume_role_policy = file("${path.root}/shared-templates/assume-role-lambda-policy.json")
    tags = var.tags
}

# --------------------------------------------------------------
############# Instance profiles###############
# --------------------------------------------------------------

# Instance Profile for Frontend Role
resource "aws_iam_instance_profile" "web_frontend_profile" {
  name = "web-frontend-profile"
  path = "/"
  role = aws_iam_role.web_frontend_role.name
}


# Instance Profile for Enrichment Role
resource "aws_iam_instance_profile" "web_enrichment_profile" {
  name = "web-enrichment-profile"
  path = "/"
  role = aws_iam_role.web_enrichment_role.name
}

# Instance Profile for Wagatildocs Role
resource "aws_iam_instance_profile" "web_wagtaildocs_profile" {
  name = "web-wagtaildocs-profile"
  path = "/"
  role = aws_iam_role.web_wagtaildocs_role.name
}

#Instance Profile for Wagtail Role
resource "aws_iam_instance_profile" "web_wagtail_profile" {
  name = "web-wagtail-profile"
  path = "/"
  role = aws_iam_role.web_wagtail_role.name
}

## Instance Profile for Forms Role
resource "aws_iam_instance_profile" "web_forms_profile" {
  name = "web-forms-profile"
  path = "/"
  role = aws_iam_role.web_forms_role.name
}

## Instance Profile for RSR Role
resource "aws_iam_instance_profile" "web_request_service_record_profile" {
  name = "web-request-service-record-profile"
  path = "/"
  role = aws_iam_role.web_request_service_record_role.name
}

## Instance Profile for HoSPREC Role
resource "aws_iam_instance_profile" "web_hosprec_profile" {
  name = "web-hosprec-profile"
  role = aws_iam_role.web_hosprec_role.name
}

## Instance Profile for Web Reverse Proxy Role
resource "aws_iam_instance_profile" "web_reverse_proxy_profile" {
    name = "web-reverse-proxy-profile"
    role = aws_iam_role.web_reverse_proxy_role.name
}

## Instance Profile for Web Search Role
resource "aws_iam_instance_profile" "web_search_profile" {
    name = "web-search-profile"
    role = aws_iam_role.web_search_role.name
}

## Instance Profile for Web Catalogue Role
resource "aws_iam_instance_profile" "web_catalogue_profile" {
    name = "web-catalogue-profile"
    role = aws_iam_role.web_catalogue_role.name
}

## Instance Profile for Web Bulkdownload Role
resource "aws_iam_instance_profile" "web_bulkdownload_profile" {
  name = "web-bulkdownload-profile"
  role = aws_iam_role.web_bulkdownload_role.name
}

#---------------------------------------------------------------------------
################### Policies ##########################################
#---------------------------------------------------------------------------

####  Attach Policies to Frontend Role
resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_1" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_2" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_3" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_4" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = var.deployment_s3_policy
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_5" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = var.application_parameter_store_policy_arn
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_6" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_7" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
}

##-------------------------------------------------------------------
#### Attach Policies to Web Catalogue Role
##-------------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_1" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_2" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_3" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = var.org_level_logging_arn
}

# resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_5" {
#   role       = aws_iam_role.web_catalogue_role.name
#   policy_arn = var.deployment_s3_policy
# }

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_4" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = var.application_parameter_store_policy_arn
}

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_5" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}

##-------------------------------------------------------------  
####### Attach Policies to Web Search Role
##-------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_1" {
  role       = aws_iam_role.web_search_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_2" {
  role       = aws_iam_role.web_search_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_3" {
  role       = aws_iam_role.web_search_role.name
  policy_arn = var.org_level_logging_arn
}

# resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_5" {
#   role       = aws_iam_role.web_search_role.name
#   policy_arn = var.deployment_s3_policy
# }

resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_4" {
  role       = aws_iam_role.web_search_role.name
  policy_arn = var.application_parameter_store_policy_arn
}

##-------------------------------------------------------------  
####### Attach Policies to Web Wagtail Role
##-------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_1" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_2" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_3" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_4" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = var.deployment_s3_policy
}

resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_5" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = var.application_parameter_store_policy_arn
}
resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_6" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
}

##-------------------------------------------------------------
############# Attach Policies to Wagtaildocs Role
##-------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_1" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_2" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_3" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = var.org_level_logging_arn
}

# resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_5" {
#   role       = aws_iam_role.web_wagtaildocs_role.name
#   policy_arn = var.deployment_s3_policy
# }

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_4" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = var.application_parameter_store_policy_arn
}

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_5" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}

##-------------------------------------------------------------
######### Attach Policies to Request Service Record Role 
##-------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_1" {
  role       = aws_iam_role.web_request_service_record_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_2" {
  role       = aws_iam_role.web_request_service_record_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_3" {
  role       = aws_iam_role.web_request_service_record_role.name
  policy_arn = var.org_level_logging_arn
  }
resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_4" {
  role       = aws_iam_role.web_request_service_record_role.name
  policy_arn = var.deployment_s3_policy
}
resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_5" {
  role       = aws_iam_role.web_request_service_record_role.name
  policy_arn = var.application_parameter_store_policy_arn
}
resource "aws_iam_role_policy_attachment" "attach_web_request_s3_copy" {
  role       = aws_iam_role.web_request_service_record_role.name
  policy_arn = var.web_request_s3_copy_policy_arn
}
resource "aws_iam_role_policy_attachment" "attach_lambda_rsr_sqs" {
  count = var.environment == "live" ? 1 : 0
  role       = aws_iam_role.lambda_web_request_service_record_role.name
  policy_arn = var.lambda_web_request_rsr_sqs_arn
}
resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_6"{
  role = aws_iam_role.web_request_service_record_role.name
  policy_arn = var.web_request_service_record_ses_access_policy_arn
}
resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_7" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = var.web_request_service_record_ec2_access_arn
}

##-------------------------------------------------------------  
####### Attach Policies to Forms Role
##-------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "web_forms_policy_attachment_1" {
  role       = aws_iam_role.web_forms_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "web_forms_policy_attachment_2" {
  role       = aws_iam_role.web_forms_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "web_forms_policy_attachment_3" {
  role       = aws_iam_role.web_forms_role.name
  policy_arn = var.org_level_logging_arn
}
# resource "aws_iam_role_policy_attachment" "web_forms_policy_attachment_4" {
#   role       = aws_iam_role.web_forms_role.name
#   policy_arn = var.deployment_s3_policy
# }
resource "aws_iam_role_policy_attachment" "web_forms_policy_attachment_4" {
  role       = aws_iam_role.web_forms_role.name
  policy_arn = var.application_parameter_store_policy_arn
}
resource "aws_iam_role_policy_attachment" "web_forms_policy_attachment_5" {
  role       = aws_iam_role.web_forms_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}

##-------------------------------------------------------------  
####### Attach Policies to HOSPREC Role
##-------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "web_hosprec_policy_attachment_1" {
  role       = aws_iam_role.web_hosprec_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "web_hosprec_policy_attachment_2" {
  role       = aws_iam_role.web_hosprec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "web_hosprec_policy_attachment_3" {
  role       = aws_iam_role.web_hosprec_role.name
  policy_arn = var.org_level_logging_arn
}
# resource "aws_iam_role_policy_attachment" "web_hosprec_policy_attachment_5" {
#   role       = aws_iam_role.web_hosprec_role.name
#   policy_arn = var.deployment_s3_policy
# }
resource "aws_iam_role_policy_attachment" "web_hosprec_policy_attachment_4" {
  role       = aws_iam_role.web_hosprec_role.name
  policy_arn = var.application_parameter_store_policy_arn
}
resource "aws_iam_role_policy_attachment" "web_hosprec_policy_attachment_5" {
  role       = aws_iam_role.web_hosprec_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}

##-------------------------------------------------------------  
####### Attach Policies to Web Enrichment Role
##-------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "web_enrichment_policy_attachment_1" {
  role       = aws_iam_role.web_enrichment_role.name
  policy_arn = var.application_parameter_store_policy_arn
}
resource "aws_iam_role_policy_attachment" "web_enrichment_policy_attachment_2" {
  role       = aws_iam_role.web_enrichment_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "web_enrichment_policy_attachment_3" {
    role       = aws_iam_role.web_enrichment_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "web_enrichment_policy_attachment_4" {
  role       = aws_iam_role.web_enrichment_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}
# resource "aws_iam_role_policy_attachment" "web_enrichment_policy_attachment_5" {
#   role       = aws_iam_role.web_enrichment_role.name
#   policy_arn = var.web_enrichment_deployment_s3_policy_arn
# }

##--------------------------------------------------------------  
####### Attach Policies to Web Search Role
##--------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "web_reverse_proxy_policy_attachment_1" {
  role       = aws_iam_role.web_reverse_proxy_role.name
  policy_arn = var.application_parameter_store_policy_arn
}
resource "aws_iam_role_policy_attachment" "web_reverse_proxy_policy_attachment_2" {
  role       = aws_iam_role.web_reverse_proxy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "web_reverse_proxy_policy_attachment_3" {
    role       = aws_iam_role.web_reverse_proxy_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "web_reverse_proxy_policy_attachment_4" {
  role       = aws_iam_role.web_reverse_proxy_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}
resource "aws_iam_role_policy_attachment" "web_reverse_proxy_policy_attachment_5" {
  role       = aws_iam_role.web_reverse_proxy_role.name
  policy_arn = var.deployment_s3_policy
}

##-------------------------------------------------------------  
####### Attach Policies to code deploy Role
##-------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "codedeploy_web_service_role_AWSCodeDeploy" {
    role       = aws_iam_role.codedeploy_web_service_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}
resource "aws_iam_role_policy_attachment" "codedeploy_web_service_role_asg_policy" {
    role       = aws_iam_role.codedeploy_web_service_role.name
    policy_arn = var.codedeploy_web_asg_policy_arn
}
resource "aws_iam_role_policy_attachment" "codedeploy_web_service_role_access_policy" {
    role       = aws_iam_role.codedeploy_web_service_role.name
    policy_arn = var.codedeploy_web_access_policy
}

resource "aws_iam_role_policy_attachment" "codedeploy_web_reverse_proxy_service_role_AWSCodeDeploy" {
    role       = aws_iam_role.codedeploy_web_reverse_proxy_service_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}
resource "aws_iam_role_policy_attachment" "codedeploy_web_reverse_proxy_service_role_asg_policy" {
    role       = aws_iam_role.codedeploy_web_reverse_proxy_service_role.name
    policy_arn = var.codedeploy_web_reverse_proxy_asg_policy_arn
}
resource "aws_iam_role_policy_attachment" "codedeploy_web_reverse_proxy_service_role_access_policy" {
    role       = aws_iam_role.codedeploy_web_reverse_proxy_service_role.name
    policy_arn = var.codedeploy_web_reverse_proxy_access_policy
}


resource "aws_iam_role_policy_attachment" "codedeploy_web_lambda_sync_s3_to_efs_full_access" {
    role       = aws_iam_role.codedeploy_web_service_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
}
resource "aws_iam_role_policy_attachment" "codedeploy_web_lambda_sync_s3_to_efs_execution" {
    role       = aws_iam_role.codedeploy_web_service_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
# resource "aws_iam_role_policy_attachment" "codedeploy_web_lambda_sync_s3_to_efs_read_content" {
#     role       = aws_iam_role.codedeploy_web_service_role.name
#     policy_arn = var.s3_deployment_source_static_content_read_arn
# }

##-------------------------------------------------------------  
####### Attach Policies to Web Bulk Download Role
##-------------------------------------------------------------

resource "aws_iam_role_policy_attachment" "web_bulkdownload_policy_attachment_1" {
  role       = aws_iam_role.web_bulkdownload_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_bulkdownload_policy_attachment_2" {
  role       = aws_iam_role.web_bulkdownload_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_bulkdownload_policy_attachment_3" {
  role       = aws_iam_role.web_bulkdownload_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "web_bulkdownload_policy_attachment_4" {
  role       = aws_iam_role.web_bulkdownload_role.name
  policy_arn = var.deployment_s3_policy
}

resource "aws_iam_role_policy_attachment" "web_bulkdownload_policy_attachment_5" {
  role       = aws_iam_role.web_bulkdownload_role.name
  policy_arn = var.application_parameter_store_policy_arn
}

resource "aws_iam_role_policy_attachment" "web_bulkdownload_policy_attachment_6" {
  role       = aws_iam_role.web_bulkdownload_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}

