# Data resource for org-session-manager-logs policy
data "aws_caller_identity" "current" {}
data "aws_iam_policy" "org_session_manager_logs" {
 arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}

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
  policy_arn = data.aws_iam_policy.org_session_manager_logs.arn
}

resource "aws_iam_role_policy_attachment" "frontend_policy_attachment_5" {
  role       = aws_iam_role.frontend_role.name
  policy_arn = var.deployment_s3_policy
}

# Instance Profile for Frontend Role
resource "aws_iam_instance_profile" "frontend_profile" {
  name = "web-frontend-profile"
  path = "/"
  role = aws_iam_role.frontend_role.name
}

# Role for Reverse Proxy
resource "aws_iam_role" "rp_role" {
  name               = "web-rp-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Attach Policies to Reverse Proxy Role
resource "aws_iam_role_policy_attachment" "rp_policy_attachment_1" {
  role       = aws_iam_role.rp_role.name
  policy_arn = var.rp_config_s3_policy_arn
}

resource "aws_iam_role_policy_attachment" "rp_policy_attachment_2" {
  role       = aws_iam_role.rp_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

# Instance Profile for Reverse Proxy Role
resource "aws_iam_instance_profile" "rp_profile" {
  name = "web-rp-profile"
  role = aws_iam_role.rp_role.name
}

# Lambda Web Docker Deployment Role
resource "aws_iam_role" "lambda_web_docker_deployment_role" {
  name               = "lambda-web-docker-deployment-role"
  assume_role_policy = file("${path.root}/shared-templates/assume-role-lambda-policy.json")
  description        = "allow lambda to call script on instances"
  tags               = var.tags
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

# Lambda AutoRunStartupScript Role
resource "aws_iam_role" "lambda_auto_run_startup_script_role" {
  name               = "LambdaSSMExecutionRole"
  assume_role_policy = file("${path.root}/shared-templates/assume-role-lambda-policy.json")
  description        = "allow lambda to call script on instances"
  tags               = var.tags
}


# Enrichment Role
resource "aws_iam_role" "enrichment_role" {
  name               = "web-enrichment-assume-role"
  assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

# Instance Profile for Enrichment Role
resource "aws_iam_instance_profile" "enrichment_profile" {
  name = "web-enrichment-profile"
  path = "/"
  role = aws_iam_role.enrichment_role.name
}

# Lambda WagtailCronTrigger Role
resource "aws_iam_role" "lambda_wagtail_cron_trigger_role" {
  name               = "WagtailLambdaExecutionRole"
  assume_role_policy = file("${path.root}/shared-templates/assume-role-lambda-policy.json")
  description        = "Allows Lambda functions to call AWS services on your behalf"
  tags               = var.tags
}
