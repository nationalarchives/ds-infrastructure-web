#!/bin/bash

LOG_FILE="/var/log/refresh_aws_keys.log"
echo "==== Script started at $(date) ====" >> $LOG_FILE

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# IAM role name
ROLE_NAME="web-wagtail-assume-role"

CREDS=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/iam/security-credentials/$ROLE_NAME)

ACCESS_KEY=$(echo "$CREDS" | jq -r '.AccessKeyId')
SECRET_KEY=$(echo "$CREDS" | jq -r '.SecretAccessKey')
SESSION_TOKEN=$(echo "$CREDS" | jq -r '.Token')

update_param() {
  local name=$1
  local value=$2

  if aws ssm put-parameter --name "$name" --value "$value" --type SecureString --overwrite >/dev/null 2>&1; then
    echo "✅ Successfully updated $name at $(date)" | tee -a "$LOG_FILE"
  else
    echo "❌ Failed to update $name at $(date)" | tee -a "$LOG_FILE"
  fi
}

update_param "/application/web/wagtail/AWS_ACCESS_KEY_ID" "$ACCESS_KEY"
update_param "/application/web/wagtail/AWS_SECRET_ACCESS_KEY" "$SECRET_KEY"
update_param "/application/web/wagtail/AWS_SESSION_TOKEN" "$SESSION_TOKEN"
