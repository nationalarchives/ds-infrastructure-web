#!/bin/bash

SCRIPT="$1"
LOG_FILE="$2"
SNS_TOPIC_ARN="$3"

"$SCRIPT" >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

if [ "$EXIT_CODE" -ne 0 ]; then
    HOSTNAME=$(hostname)

    # Get EC2 instance metadata token
    TOKEN=$(curl -s -X PUT \
      -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
      http://169.254.169.254/latest/api/token)

    # Get EC2 instance ID
    INSTANCE_ID=$(curl -s \
      -H "X-aws-ec2-metadata-token: $TOKEN" \
      http://169.254.169.254/latest/meta-data/instance-id)

    # Get AWS account ID
    ACCOUNT_ID=$(aws sts get-caller-identity \
      --query Account \
      --output text)

    # Get environment name from SNS topic ARN
    ACCOUNT_NAME=$(echo "$SNS_TOPIC_ARN" | sed 's/.*web-cron-failures-//')

    # Get current time
    CURRENT_TIME=$(date)

    # Publish custom Amazon Q notification
    aws sns publish \
      --topic-arn "$SNS_TOPIC_ARN" \
      --message "{
        \"version\": \"1.0\",
        \"source\": \"custom\",
        \"content\": {
          \"textType\": \"client-markdown\",
          \"title\": \":warning: Wagtail Cron Failure\",
          \"description\": \"Wagtail cron job failed.\\n\\nAccount: $ACCOUNT_NAME ($ACCOUNT_ID)\\nInstance ID: $INSTANCE_ID\\nHostname: $HOSTNAME\\nScript: $SCRIPT\\nExit code: $EXIT_CODE\\nTime: $CURRENT_TIME\",
          \"nextSteps\": [
            \"Check the Wagtail cron logs\",
            \"Check the affected EC2 instance\"
          ],
          \"keywords\": [
            \"Wagtail\",
            \"Cron\",
            \"Failure\"
          ]
        }
      }" \
      >> /var/log/cron-notification.log 2>&1
fi

exit "$EXIT_CODE"
