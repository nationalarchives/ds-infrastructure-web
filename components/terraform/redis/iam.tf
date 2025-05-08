resource "aws_iam_policy" "redis_deployment_s3" {
    name        = "platform-redis-source-s3-policy"
    description = "deployment S3 access for web redis"

    policy = templatefile("${path.module}/templates/deployment-source-s3-access.json", {
        deployment_s3_bucket = var.deployment_s3_bucket,
        service              = "web"
    })
}

resource "aws_iam_role" "redis_role" {
    name = "platform-redis-assume-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
    role       = aws_iam_role.redis_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
    role       = aws_iam_role.redis_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "service_role_ssm" {
    role       = aws_iam_role.redis_role.name
    policy_arn = aws_iam_policy.redis_deployment_s3.arn
}

resource "aws_iam_instance_profile" "platform_redis_profile" {
    name = "platform-redis-profile"
    role = aws_iam_role.redis_role.name
}
