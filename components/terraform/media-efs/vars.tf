variable "vpc_id" {}
variable "private_subs" {}

variable "media_efs_backup_schedule" {}
variable "media_efs_backup_start_window" {}
variable "media_efs_backup_completion_window" {}
variable "media_efs_backup_cold_storage_after" {}
variable "media_efs_backup_delete_after" {}
variable "media_efs_backup_kms_key_arn" {}

variable "tags" {}
