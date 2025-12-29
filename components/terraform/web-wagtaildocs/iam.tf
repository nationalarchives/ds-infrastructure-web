resource "aws_iam_role" "web_wagtaildocs_role" {
    name = "web-wagtaildocs-assume-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

resource "aws_iam_instance_profile" "web_wagtaildocs_profile" {
    name = "web-wagtaildocs-profile"
    role = aws_iam_role.web_wagtaildocs_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
    role       = aws_iam_role.web_wagtaildocs_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "service_role_ssm" {
    role       = aws_iam_role.web_wagtaildocs_role.name
    policy_arn = aws_iam_policy.web_wagtaildocs_deployment_s3.arn
}
resource "aws_iam_policy" "web_wagtaildocs_deployment_s3" {
    name        = "web-wagtaildocs-source-s3-policy"
    description = "deployment S3 access for web-wagtaildocs"
    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = "web-wagtaildocs"
    })
}
