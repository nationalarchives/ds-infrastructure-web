resource "aws_iam_role" "web_media_efs_backup" {
    name = "web-media-efs-backup-role"

    assume_role_policy = file("${path.module}/templates/efs_backup_assume_role.json")
    
}
resource "aws_iam_role_policy_attachment" "web_media_efs_backup_policy" {
  role       = aws_iam_role.web_media_efs_backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}