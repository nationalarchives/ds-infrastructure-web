data "aws_ami" "web_frontend_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-frontend"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_frontend_image_version]
    }
}

data "aws_ami" "web_request_service_record_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-request-service-record"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_request_service_record_image_version]
    }
}

data "aws_ami" "web_wagtail_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-wagtail"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_wagtail_image_version]
    }
}

data "aws_ami" "web_enrichment_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-enrichment"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_enrichment_image_version]
    }
}
        
data "aws_ami" "redis_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-platform-redis"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.redis_image_version]
    }
}

data "aws_ami" "web_catalogue_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-catalogue"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_catalogue_image_version]
    }
}

data "aws_ami" "web_search_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-search"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_search_image_version]
    }
}
    
data "aws_ami" "web_wagtaildocs_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-wagtaildocs"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_wagtaildocs_image_version]
    }
}

data "aws_ami" "web_forms_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-forms"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_forms_image_version]
    }
}

data "aws_ami" "web_reverse_proxy_ami" {
  owners = ["self"]

  filter {
    name   = "tag:Image"
    values = ["ds-web-reverse-proxy"]
  }

  filter {
    name   = "tag:ImageVersion"
    values = [var.web_reverse_proxy_image_version]
  }
}

data "aws_ami" "web_hospitalrecords_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-hospitalrecords"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_hospitalrecords_image_version]
    }
}

data "aws_ami" "web_bulkdownload_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-bulkdownload"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_bulkdownload_image_version]
    }
}

data "aws_ami" "web_feedback_ami" {
    owners = ["self"]

    filter {
        name   = "tag:Image"
        values = ["ds-web-feedback"]
    }

    filter {
        name   = "tag:ImageVersion"
        values = [var.web_feedback_image_version]
    }
}
