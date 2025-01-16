variable "email_address" {}

module "cp-ses" {
    source = "./ses"

    email_address = var.email_address
}
