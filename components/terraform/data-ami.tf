data "aws_ami" "frontend_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "web-frontend-primer*"
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

data "aws_ami" "wagtail_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "wagtail-primer*"
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

data "aws_ami" "enrichment_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "web-enrichment-primer*"
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

data "aws_ami" "redis_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "platform-redis-primer*"
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

data "aws_ami" "catalogue_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "catalogue-primer*"
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


data "aws_ami" "search_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "search-primer*"
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

data "aws_ami" "wagtaildocs_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "wagtaildocs-primer*"
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
