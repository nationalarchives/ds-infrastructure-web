resource "aws_iam_policy" "request_service_record_deployment_s3" {
    name        = "request-service-record-source-s3-policy"
    description = "deployment S3 access for mod-foi frontend"

    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = "request-service-record"
    })
}

resource "aws_iam_role" "request_service_record_role" {
    name = "request-service-record-assume-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
    role       = aws_iam_role.request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
    role       = aws_iam_role.request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "service_role_ssm" {
    role       = aws_iam_role.request_service_record_role.name
    policy_arn = aws_iam_policy.request_service_record_deployment_s3.arn
}

resource "aws_iam_instance_profile" "request_service_record_profile" {
    name = "request-service-record-profile"
    role = aws_iam_role.request_service_record_role.name
}
