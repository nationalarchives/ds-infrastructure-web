resource "aws_iam_role" "media_efs_backup" {
    name = "web-media-efs-backup-role"

    assume_role_policy  = file("${path.root}/shared-templates/efs_backup_assume_role.json")
    managed_policy_arns = [
        "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
    ]
}
