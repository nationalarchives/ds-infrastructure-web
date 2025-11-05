#!/bin/bash

LOG_FILE="/var/log/server-startup.log"
echo "$(date '+%Y-%m-%d %T') - Starting Redis container" | sudo tee -a "$LOG_FILE" > /dev/null

cd /var/docker || exit 1

# Ensure compose is available
if ! command -v docker-compose &>/dev/null && ! docker compose version &>/dev/null; then
  echo "$(date '+%Y-%m-%d %T') - docker compose not found!" | sudo tee -a "$LOG_FILE" > /dev/null
  exit 1
fi

# Start only Redis service
echo "$(date '+%Y-%m-%d %T') - Running docker-compose for Redis" | sudo tee -a "$LOG_FILE" > /dev/null
sudo docker-compose up -d redis

echo "$(date '+%Y-%m-%d %T') - Redis startup complete" | sudo tee -a "$LOG_FILE" > /dev/null
