resource "aws_ses_email_identity" "official_publishing" {
    email = var.email_address
}
