resource "aws_sns_topic" "wagtail_migration_failures" {
  name = "wagtail-migration-failures-${var.environment}"
}
