variable "email_address" {}

module "etna-ses" {
    source = "./ses"

    email_address = var.email_address
}
