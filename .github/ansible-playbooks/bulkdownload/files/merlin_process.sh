#!/bin/bash
set -e

TASK="$1"

CONTAINER=$(sudo docker ps --format "{{.Names}}" | grep -E "^blue-web$|^green-web$" | head -1)

if [ -z "$CONTAINER" ]; then
    echo "$(date): No active blue-web or green-web container found"
    exit 1
fi

echo "$(date): Running Merlin task '$TASK' in container '$CONTAINER'"

sudo docker exec "$CONTAINER" poetry run python tasks/process.py merlin "$TASK"
