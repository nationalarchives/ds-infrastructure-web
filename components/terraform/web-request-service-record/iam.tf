resource "aws_iam_role" "web_request_service_record_role" {
    name = "web-request-service-record-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}
resource "aws_iam_instance_profile" "web_request_service_record_profile" {
    name = "web-request-service-record-profile"
    path = "/"
    role = aws_iam_role.web_request_service_record_role.name
}

resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_1" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}
resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_2" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_3" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_4" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = var.org_level_logging_arn
}
resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_5" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = aws_iam_policy.ec2_access.arn
}
resource "aws_iam_role_policy_attachment" "rsr_policy_attachment_6" {
    role       = aws_iam_role.web_request_service_record_role.name
    policy_arn = aws_iam_policy.ses_access.arn
}
# The following block is commented out because James says the S3 PutObject requests were working without it
# resource "aws_iam_role_policy_attachment" "web_rsr_policy_attachment_7" {
#     role       = aws_iam_role.web_request_service_record_role.name
#     policy_arn = var.foi1939_register_write_policy_arn
# }

resource "aws_iam_policy" "ec2_access" {
    name        = "web-request-service-record-ec2-access-policy"
    description = "ec2 access for web-request-service-record"
    policy      = data.aws_iam_policy_document.ec2_access.json
}

resource "aws_iam_policy" "ses_access" {
    name        = "web-request-service-record-ses-access-policy"
    description = "ses access for web-request-service-record"
    policy      = data.aws_iam_policy_document.ses_access.json
}