output "ses_email_address" {
    value = aws_ses_email_identity.official_publishing.email
}

output "ses_arn" {
    value = aws_ses_email_identity.official_publishing.arn
}
