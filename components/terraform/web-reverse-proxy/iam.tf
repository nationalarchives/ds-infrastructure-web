data "aws_caller_identity" "current" {}

resource "aws_iam_role" "web_reverse_proxy_role" {
    name = "web-reverse-proxy-assume-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

resource "aws_iam_instance_profile" "web_reverse_proxy_profile" {
    name = "web-reverse-proxy-profile"
    role = aws_iam_role.web_reverse_proxy_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
    role       = aws_iam_role.web_reverse_proxy_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "service_role_ssm" {
    role       = aws_iam_role.web_reverse_proxy_role.name
    policy_arn = aws_iam_policy.web_reverse_proxy_deployment_s3.arn
}
resource "aws_iam_policy" "web_reverse_proxy_deployment_s3" {
    name        = "web-reverse-proxy-source-s3-policy"
    description = "deployment S3 access for web reverse proxy"     
    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = "web-reverse-proxy"
    })
}
resource "aws_iam_role_policy_attachment" "web_reverse_proxy_policy_attachment_7" {
  role       = aws_iam_role.web_reverse_proxy_role.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/org-session-manager-logs"
}