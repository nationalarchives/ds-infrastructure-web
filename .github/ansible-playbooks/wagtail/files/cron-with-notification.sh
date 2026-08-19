#!/bin/bash

SCRIPT="$1"
LOG_FILE="$2"
SNS_TOPIC_ARN="$3"

"$SCRIPT" >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

if [ "$EXIT_CODE" -ne 0 ]; then
    HOSTNAME=$(hostname)

    aws sns publish \
      --topic-arn "$SNS_TOPIC_ARN" \
      --subject "Wagtail Cron Failure" \
      --message "Wagtail cron script failed.

Script: $SCRIPT
Host: $HOSTNAME
Exit code: $EXIT_CODE
Time: $(date)" \
      >> /var/log/cron-notification.log 2>&1
fi

exit "$EXIT_CODE"
