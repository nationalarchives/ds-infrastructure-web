resource "aws_iam_role" "request_service_record_role" {
    name = "request-service-record-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}
resource "aws_iam_instance_profile" "request_service_record_profile" {
    name = "request-service-record-profile"
    path = "/"
    role = aws_iam_role.request_service_record_role.name
}

resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_1" {
    role       = aws_iam_role.request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_2" {
    role       = aws_iam_role.request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_3" {
    role       = aws_iam_role.request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_4" {
    role       = aws_iam_role.request_service_record_role.name
    policy_arn = var.org_level_logging_arn
}
resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_5" {
    role       = aws_iam_role.request_service_record_role.name
    policy_arn = aws_iam_policy.ec2_access.arn
}

resource "aws_iam_policy" "ec2_access" {
    name        = "request-service-record-source-s3-policy"
    description = "ec2 access for request-service-record"
    policy      = data.aws_iam_policy_document.ec2_access.json
}
