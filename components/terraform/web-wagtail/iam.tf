resource "aws_iam_role" "web_wagtail_role" {
    name = "web-wagtail-assume-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

resource "aws_iam_instance_profile" "web_wagtail_profile" {
    name = "web-wagtail-profile"
    role = aws_iam_role.web_wagtail_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
    role       = aws_iam_role.web_wagtail_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "service_role_ssm" {
    role       = aws_iam_role.web_wagtail_role.name
    policy_arn = aws_iam_policy.web_wagtail_deployment_s3.arn
}
resource "aws_iam_policy" "web_wagtail_deployment_s3" {
    name        = "web-wagtail-source-s3-policy"
    description = "deployment S3 access for web-wagtail"    
    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = "web-wagtail"
    })
}
