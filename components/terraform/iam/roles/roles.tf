# roles and profiles for Django/Wagtail
#
resource "aws_iam_role" "frontend_role" {
    name               = "web-frontend-assume-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        var.deployment_s3_policy,
    ]
}

resource "aws_iam_instance_profile" "frontend_profile" {
    name = "web-frontend-profile"
    path = "/"
    role = aws_iam_role.frontend_role.name
}

# roles and profiles for reverse proxy
resource "aws_iam_role" "rp_role" {
    name               = "web-rp-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")

    managed_policy_arns = [
        var.rp_config_s3_policy_arn,
        "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
    ]
}

resource "aws_iam_instance_profile" "rp_profile" {
    name = "web-rp-profile"
    role = aws_iam_role.rp_role.name
}

resource "aws_iam_role" "lambda_web_docker_deployment_role" {
    name               = "lambda-web-docker-deployment-role"
    assume_role_policy = file("${path.root}/shared-templates/assume-role-lambda-policy.json")

    managed_policy_arns = [
        "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
        var.lambda_web_docker_deployment_policy_arn
    ]

    description = "allow lambda to call script on instances"

    tags = var.tags
}
