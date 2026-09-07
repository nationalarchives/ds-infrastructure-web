data "aws_s3_bucket" "deployment_source" {
  bucket = "ds-${var.environment}-deployment-source"
}

resource "aws_cloudfront_trust_store" "worldpay" {
  name = var.environment == "staging" ? "worldpay" : "worldpay-${var.environment}"

  ca_certificates_bundle_source {
    ca_certificates_bundle_s3_location {
      bucket = data.aws_s3_bucket.deployment_source.id
      key    = "cloudfront/worldpay/worldpay-trust-store.pem"
      region = "eu-west-2"
    }
  }

  tags = var.default_tags
}
