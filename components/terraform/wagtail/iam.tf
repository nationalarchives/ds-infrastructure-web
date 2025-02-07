resource "aws_iam_role" "wagtail_role" {
    name = "wagtail-assume-role"
    assume_role_policy = file("${path.root}/shared-templates/ec2_assume_role.json")
}

resource "aws_iam_instance_profile" "wagtail_profile" {
    name = "wagtail-profile"
    role = aws_iam_role.wagtail_role.name
}
