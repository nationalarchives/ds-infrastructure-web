## Roles
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

# Lambda Web Docker Deployment Role
resource "aws_iam_role" "lambda_web_docker_deployment_role" {
  name               = "lambda-web-docker-deployment-role"
  assume_role_policy = file("${path.root}/shared-templates/assume-role-lambda-policy.json")
  description        = "allow lambda to call script on instances"
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



## Instance profiles

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



## Policies

# Attach Policies to Frontend Role
resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_1" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_2" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_3" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_4" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_5" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = var.deployment_s3_policy
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_6" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_7" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}

resource "aws_iam_role_policy_attachment" "web_frontend_policy_attachment_8" {
  role       = aws_iam_role.web_frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
}

# Attach Policies to Lambda Web Docker Deployment Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_1" {
  role       = aws_iam_role.lambda_web_docker_deployment_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment_2" {
  role       = aws_iam_role.lambda_web_docker_deployment_role.name
  policy_arn = var.lambda_web_docker_deployment_policy_arn
}


# Attach Policies to Web Catalogue Role
resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_1" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_2" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_3" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_4" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_5" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = var.deployment_s3_policy
}

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_6" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "web_catalogue_policy_attachment_7" {
  role       = aws_iam_role.web_catalogue_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}
  
# Attach Policies to Web Search Role
resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_1" {
  role       = aws_iam_role.web_search_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_2" {
  role       = aws_iam_role.web_search_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_3" {
  role       = aws_iam_role.web_search_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_4" {
  role       = aws_iam_role.web_search_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_5" {
  role       = aws_iam_role.web_search_role.name
  policy_arn = var.deployment_s3_policy
}

resource "aws_iam_role_policy_attachment" "web_search_policy_attachment_6" {
  role       = aws_iam_role.web_search_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

# Attach Policies to Web Wagtail Role
resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_1" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_2" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_3" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_4" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_5" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = var.deployment_s3_policy
}

resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_6" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}
resource "aws_iam_role_policy_attachment" "web_wagtail_policy_attachment_7" {
  role       = aws_iam_role.web_wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
}


# Attach Policies to Wagtaildocs Role
resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_1" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_2" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_3" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_4" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_5" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = var.deployment_s3_policy
}

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_6" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "web_wagtaildocs_policy_attachment_7" {
  role       = aws_iam_role.web_wagtaildocs_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}

# Request Service Record Role - MoD FoI

  resource "aws_iam_role" "web_request_service_record_role" {
    name = "web-request-service-record-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
  }
  resource "aws_iam_instance_profile" "web_request_service_record_profile" {
    name = "web-request-service-record-profile"
    path = "/"
    role = aws_iam_role.web_request_service_record_role.name
  }
  # Attach Policies to Request Service Record Role
  resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_1" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  }
  resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_2" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }
  resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_3" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_4" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = var.org_level_logging_arn
  }
  resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_5" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = var.deployment_s3_policy
  }
  resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_6" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
  }
