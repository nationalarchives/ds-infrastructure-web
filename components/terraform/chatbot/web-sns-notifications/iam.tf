resource "aws_iam_role" "chatbot_role" {
  count = var.environment == "live" ? 1 : 0
  name  = "chatbot-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "chatbot.amazonaws.com"
        }
      }
    ]
  })
}

# Optional: Attach SNS read-only policy
resource "aws_iam_role_policy_attachment" "chatbot_sns_access" {
  count      = var.environment == "live" ? 1 : 0
  role       = aws_iam_role.chatbot_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSReadOnlyAccess"
}
