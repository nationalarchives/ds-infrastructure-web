data "aws_ami" "frontend_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "web-frontend*"
        ]
    }

    filter {
        name   = "virtualization-type"
        values = [
            "hvm"
        ]
    }

    owners = [
        data.aws_caller_identity.current.account_id,
        "amazon"
    ]
}
