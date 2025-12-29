data "aws_ami" "web_frontend_ami" {
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

data "aws_ami" "request_service_record_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "request-service-record-primer*"
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

data "aws_ami" "webwagtail_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "web-wagtail-primer*"
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

data "aws_ami" "web_enrichment_ami" {
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

data "aws_ami" "web_catalogue_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "web-catalogue-primer*"
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

data "aws_ami" "web_wagtaildocs_ami" {
    most_recent = true

    filter {
        name   = "name"
        values = [
            "web-wagtaildocs-primer*"
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
