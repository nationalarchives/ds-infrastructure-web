variable "media_efs_backup_schedule" {}
variable "media_efs_backup_start_window" {}
variable "media_efs_backup_completion_window" {}
variable "media_efs_backup_cold_storage_after" {}
variable "media_efs_backup_delete_after" {}
variable "media_efs_backup_kms_key_arn" {}

module "media_efs" {
    source = "./media-efs"

    vpc_id = data.aws_ssm_parameter.vpc_id.value
    private_subs = [
        data.aws_ssm_parameter.private_subnet_2a_id.value,
        data.aws_ssm_parameter.private_subnet_2b_id.value,
    ]

    media_efs_backup_schedule           = var.media_efs_backup_schedule
    media_efs_backup_start_window       = var.media_efs_backup_start_window
    media_efs_backup_completion_window  = var.media_efs_backup_completion_window
    media_efs_backup_cold_storage_after = var.media_efs_backup_cold_storage_after
    media_efs_backup_delete_after       = var.media_efs_backup_delete_after
    media_efs_backup_kms_key_arn        = var.media_efs_backup_kms_key_arn

    tags = local.tags
}
