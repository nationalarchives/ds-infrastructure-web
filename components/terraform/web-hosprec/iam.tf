resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
    #role       = aws_iam_role.web_hosprec_role.name
    role       = var.web_hosprec_role_name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "service_role_ssm" {
    #role       = aws_iam_role.web_hosprec_role.name
    role       = var.web_hosprec_role_name
    policy_arn = aws_iam_policy.web_hosprec_deployment_s3.arn
}
resource "aws_iam_policy" "web_hosprec_deployment_s3" {
    name        = "web-hosprec-source-s3-policy"
    description = "deployment S3 access for web hosprec"     
    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = "web-hosprec"
    })
}
