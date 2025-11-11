#!/bin/bash

CONTAINER=$(sudo docker ps --format '{{.Names}}' | grep -E 'blue-web|green-web' | head -n 1)

if [ -n "$CONTAINER" ]; then
  echo "$(date): Running weekly task populate.py inside $CONTAINER" >> /var/log/weekly_task.log
  sudo docker-compose -f /var/docker/compose.yml exec -T "$CONTAINER" poetry run python /app/populate.py >> /var/log/weekly_task.log 2>&1
else
  echo "$(date): No active container found for weekly task" >> /var/log/weekly_task.log
fi
