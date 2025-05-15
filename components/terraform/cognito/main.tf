resource "aws_cognito_user_pool" "cognito_user_pool" {
    name = var.cognito_user_pool_name

    auto_verified_attributes = [
        "email",
    ]

    email_configuration {
        source_arn             = var.ses_sysdev_arn
        reply_to_email_address = var.ses_sysdev_email
        email_sending_account  = "DEVELOPER"
    }

    lambda_config {
        pre_sign_up = "arn:aws:lambda:eu-west-2:${var.account_id}:function:cognito-signup-validation"
    }

    password_policy {
        minimum_length    = 12
        require_lowercase = true
        require_numbers   = true
        require_symbols   = true
        require_uppercase = true

        temporary_password_validity_days = 7
    }

    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "email"
        required                 = true

        string_attribute_constraints {
            min_length = 1
            max_length = 2048
        }
    }

    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "name"
        required                 = true

        string_attribute_constraints {
            min_length = 1
            max_length = 2048
        }
    }

    schema {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "address"
        required                 = false

        string_attribute_constraints {
            min_length = 1
            max_length = 2048
        }
    }

    tags = merge( var.tags, {
        "Name" = var.cognito_user_pool_name
    })
}


resource "aws_cognito_user_pool_domain" "user_pool" {
    certificate_arn = var.certificate_arn
    domain          = var.user_pool_domain
    user_pool_id    = aws_cognito_user_pool.cognito_user_pool.id
}

resource "aws_cognito_user_pool_ui_customization" "user_pool_ui" {
    client_id = aws_cognito_user_pool_client.user_pool_client.id

    css        = file("${path.module}/ui/client.css")
    image_file = filebase64("${path.module}/ui/logo-white.png")

    user_pool_id = aws_cognito_user_pool_domain.user_pool.user_pool_id
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
    name = var.user_pool_client_name

    user_pool_id           = aws_cognito_user_pool.cognito_user_pool.id
    #generate_secret        = true
    refresh_token_validity = 1

    allowed_oauth_flows_user_pool_client = true

    callback_urls = var.nationalarchives_callback_url
    logout_urls   = var.nationalarchives_logout_url

    supported_identity_providers = [
        "COGNITO"
    ]

    allowed_oauth_flows = [
        "code"
    ]

    allowed_oauth_scopes = [
        "email",
        "openid",
        "profile",
        "aws.cognito.signin.user.admin",
    ]

    read_attributes = [
        "email",
        "name",
        "address",
    ]

    write_attributes = [
        "email",
        "name",
        "address",
    ]
}

resource "aws_cognito_user_pool_ui_customization" "tna_cognito" {
    client_id = aws_cognito_user_pool_client.user_pool_client.id

    css        = file("${path.module}/ui/client.css")
    image_file = filebase64("${path.module}/ui/logo-white.png")

    # Refer to the aws_cognito_user_pool_domain resource's
    user_pool_id = aws_cognito_user_pool_domain.user_pool.user_pool_id
}