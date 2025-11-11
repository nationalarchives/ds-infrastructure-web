#!/bin/bash

CONTAINER=$(sudo docker ps --format '{{.Names}}' | grep -E 'blue-web|green-web' | head -n 1)

if [ -n "$CONTAINER" ]; then
  echo "$(date): Running task inside $CONTAINER" >> /var/log/daily_task.log
  sudo docker-compose -f /var/docker/compose.yml exec -T "$CONTAINER" poetry run python /app/add_new.py >> /var/log/daily_task.log 2>&1
else
  echo "$(date): No active container found" >> /var/log/daily_task.log
fi