#!/bin/bash

RUNNING_CONTAINER=$(sudo docker ps --format '{{.Names}}' | grep -E 'blue-web|green-web' | head -n 1)

if [ -z "$RUNNING_CONTAINER" ]; then
  echo "$(date): No web container is running!" | sudo tee -a /var/log/fix_remapped_domains.log
  exit 1
fi

echo "$(date): Running fix_remapped_domains.py inside $RUNNING_CONTAINER" | sudo tee -a /var/log/fix_remapped_domains.log
sudo docker-compose -f /var/docker/compose.yml exec "$RUNNING_CONTAINER" poetry run python /app/fix_remapped_domains.py 2>&1 | sudo tee -a /var/log/fix_remapped_domains.log