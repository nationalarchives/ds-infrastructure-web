resource "aws_iam_role" "web_forms_role" {
    name = "web-forms-assume-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

resource "aws_iam_instance_profile" "web_forms_profile" {
    name = "web-forms-profile"
    role = aws_iam_role.web_forms_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
    role       = aws_iam_role.web_forms_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "service_role_ssm" {
    role       = aws_iam_role.web_forms_role.name
    policy_arn = aws_iam_policy.web_forms_deployment_s3.arn
}
resource "aws_iam_policy" "web_forms_deployment_s3" {
    name        = "web-forms-source-s3-policy"
    description = "deployment S3 access for web forms"     
    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = "web-forms"
    })
}
