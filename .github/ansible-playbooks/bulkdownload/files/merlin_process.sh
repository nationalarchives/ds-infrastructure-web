#!/bin/bash

set -e

TASK="$1"

SNS_TOPIC_ARN=$(aws ssm get-parameter \
    --name "/application/web/bulkdownload/MERLIN_PROCESS_SNS_TOPIC_ARN" \
    --with-decryption \
    --region eu-west-2 \
    --query "Parameter.Value" \
    --output text)

CONTAINER=$(sudo docker ps --format "{{.Names}}" | grep -E "^blue-web$|^green-web$" | head -1)

if [ -z "$CONTAINER" ]; then
    echo "$(date): No active blue-web or green-web container found"
    exit 1
fi

echo "$(date): Running Merlin task '$TASK' in container '$CONTAINER'"

set +e
sudo docker exec "$CONTAINER" poetry run python tasks/process.py merlin "$TASK"
EXIT_CODE=$?
set -e

if [ "$EXIT_CODE" -ne 0 ]; then
    echo "$(date): Merlin task '$TASK' failed with exit code $EXIT_CODE"

    aws sns publish \
        --topic-arn "$SNS_TOPIC_ARN" \
        --subject "Merlin Process Failure" \
        --message "{\"version\":\"1.0\",\"source\":\"custom\",\"content\":{\"description\":\"Merlin task '$TASK' failed on $(hostname) with exit code $EXIT_CODE. Container: $CONTAINER. Time: $(date).\"}}" \
        --region eu-west-2

    exit "$EXIT_CODE"
fi

echo "$(date): Merlin task '$TASK' completed successfully."
