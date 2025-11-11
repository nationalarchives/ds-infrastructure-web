## Roles

# Frontend Role
resource "aws_iam_role" "frontend_role" {
  name               = "web-frontend-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# wagtail Role
resource "aws_iam_role" "wagtail_role" {
  name               = "wagtail-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Catalogue Role
resource "aws_iam_role" "catalogue_role" {
  name               = "catalogue-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Search Role
resource "aws_iam_role" "search_role" {
  name               = "search-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}


# Enrichment Role
resource "aws_iam_role" "enrichment_role" {
  name               = "web-enrichment-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# wagtaildocs Role
resource "aws_iam_role" "wagtaildocs_role" {
  name               = "wagtaildocs-assume-role"
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
resource "aws_iam_instance_profile" "frontend_profile" {
  name = "web-frontend-profile"
  path = "/"
  role = aws_iam_role.frontend_role.name
}


# Instance Profile for Enrichment Role
resource "aws_iam_instance_profile" "enrichment_profile" {
  name = "web-enrichment-profile"
  path = "/"
  role = aws_iam_role.enrichment_role.name
}

# Instance Profile for Wagatildocs Role
resource "aws_iam_instance_profile" "wagtaildocs_profile" {
  name = "wagtaildocs-profile"
  path = "/"
  role = aws_iam_role.wagtaildocs_role.name
}


## Policies

# Attach Policies to Frontend Role
resource "aws_iam_role_policy_attachment" "frontend_policy_attachment_1" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "frontend_policy_attachment_2" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "frontend_policy_attachment_3" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "frontend_policy_attachment_4" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "frontend_policy_attachment_5" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = var.deployment_s3_policy
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


# Attach Policies to Catalogue Role
resource "aws_iam_role_policy_attachment" "catalogue_policy_attachment_1" {
  role       = aws_iam_role.catalogue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "catalogue_policy_attachment_2" {
  role       = aws_iam_role.catalogue_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "catalogue_policy_attachment_3" {
  role       = aws_iam_role.catalogue_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "catalogue_policy_attachment_4" {
  role       = aws_iam_role.catalogue_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "catalogue_policy_attachment_5" {
  role       = aws_iam_role.catalogue_role.name
  policy_arn = var.deployment_s3_policy
}


# Attach Policies to Search Role
resource "aws_iam_role_policy_attachment" "search_policy_attachment_1" {
  role       = aws_iam_role.search_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "search_policy_attachment_2" {
  role       = aws_iam_role.search_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "search_policy_attachment_3" {
  role       = aws_iam_role.search_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "search_policy_attachment_4" {
  role       = aws_iam_role.search_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "search_policy_attachment_5" {
  role       = aws_iam_role.search_role.name
  policy_arn = var.deployment_s3_policy
}

# Attach Policies to Wagtail Role
resource "aws_iam_role_policy_attachment" "wagtail_policy_attachment_1" {
  role       = aws_iam_role.wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "wagtail_policy_attachment_2" {
  role       = aws_iam_role.wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "wagtail_policy_attachment_3" {
  role       = aws_iam_role.wagtail_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "wagtail_policy_attachment_4" {
  role       = aws_iam_role.wagtail_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "wagtail_policy_attachment_5" {
  role       = aws_iam_role.wagtail_role.name
  policy_arn = var.deployment_s3_policy
}

# Attach Policies to Wagtaildocs Role
resource "aws_iam_role_policy_attachment" "wagtaildocs_policy_attachment_1" {
  role       = aws_iam_role.wagtaildocs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "wagtaildocs_policy_attachment_2" {
  role       = aws_iam_role.wagtaildocs_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "wagtaildocs_policy_attachment_3" {
  role       = aws_iam_role.wagtaildocs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "wagtaildocs_policy_attachment_4" {
  role       = aws_iam_role.wagtaildocs_role.name
  policy_arn = var.org_level_logging_arn
}

resource "aws_iam_role_policy_attachment" "wagtaildocs_policy_attachment_5" {
  role       = aws_iam_role.wagtaildocs_role.name
  policy_arn = var.deployment_s3_policy
}
resource "aws_iam_role_policy_attachment" "wagtaildocs_policy_attachment_6" {
  role       = aws_iam_role.wagtaildocs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

# Request Service Record Role - MoD FoI
#
#resource "aws_iam_role" "request_service_record_role" {
#    name = "request-service-record-role"
#    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
#}
#resource "aws_iam_instance_profile" "request_service_record_profile" {
#    name = "request-service-record-profile"
#    path = "/"
#    role = aws_iam_role.request_service_record_role.name
#}
## Attach Policies to Request Service Record Role
#resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_1" {
#    role       = aws_iam_role.request_service_record_role.name
#    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
#}
#resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_2" {
#    role       = aws_iam_role.request_service_record_role.name
#    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
#}
#resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_3" {
#    role       = aws_iam_role.request_service_record_role.name
#    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#}
#resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_4" {
#    role       = aws_iam_role.request_service_record_role.name
#    policy_arn = var.org_level_logging_arn
#}
#resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_5" {
#    role       = aws_iam_role.request_service_record_role.name
#    policy_arn = var.deployment_s3_policy
#}
