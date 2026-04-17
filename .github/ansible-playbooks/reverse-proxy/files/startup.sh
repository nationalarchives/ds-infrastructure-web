#!/bin/bash
set -e

COMPOSE_FILE="/var/docker/compose.yml"

BLUE="blue-web"
GREEN="green-web"

echo "===== BLUE-GREEN DEPLOY START ====="

BLUE_UP=$(sudo docker ps --filter name=$BLUE --format "{{.Names}}")
GREEN_UP=$(sudo docker ps --filter name=$GREEN --format "{{.Names}}")

if [ -z "$BLUE_UP" ] && [ -z "$GREEN_UP" ]; then
    ACTIVE=""
    NEW="blue"
elif [ -n "$BLUE_UP" ]; then
    ACTIVE="blue"
    NEW="green"
else
    ACTIVE="green"
    NEW="blue"
fi

ACTIVE_C="${ACTIVE}-web"
NEW_C="${NEW}-web"

echo "Switching: ${ACTIVE:-none} -> $NEW"

# start new container FIRST
sudo docker compose -f $COMPOSE_FILE up -d $NEW_C

echo "Waiting for container to stabilize..."
sleep 10

echo "Testing health..."

HEALTH_OK=0

for i in {1..20}; do
    if sudo docker exec $NEW_C curl -f http://127.0.0.1/ >/dev/null 2>&1; then
        HEALTH_OK=1
        break
    fi
    sleep 2
done

if [ "$HEALTH_OK" -ne 1 ]; then
    echo "❌ NEW container failed health check"

    sudo docker rm -f $NEW_C || true

    if [ -n "$ACTIVE_C" ]; then
        sudo docker compose -f $COMPOSE_FILE up -d $ACTIVE_C
    fi

    exit 1
fi

echo "Switching traffic..."

if [ -n "$ACTIVE_C" ]; then
    sudo docker rm -f $ACTIVE_C || true
fi

echo "===== DEPLOY SUCCESS: $NEW ====="