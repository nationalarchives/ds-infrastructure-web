#!/bin/bash
set -e

COMPOSE_FILE="/var/docker/compose.yml"

BLUE="blue-web"
GREEN="green-web"

echo "===== BLUE-GREEN DEPLOY START ====="

BLUE_UP=$(sudo docker ps -a --filter name=$BLUE --format "{{.Names}}")
GREEN_UP=$(sudo docker ps -a --filter name=$GREEN --format "{{.Names}}")

if [ -z "$BLUE_UP" ] && [ -z "$GREEN_UP" ]; then
    ACTIVE=""
    NEW="blue"
elif sudo docker ps --filter name=$BLUE --format "{{.Names}}" | grep -q blue-web; then
    ACTIVE="blue"
    NEW="green"
else
    ACTIVE="green"
    NEW="blue"
fi

ACTIVE_C="${ACTIVE}-web"
NEW_C="${NEW}-web"

echo "Switching: ${ACTIVE:-none} -> $NEW"

# Start container (IMPORTANT: capture failure)
if ! sudo docker-compose -f $COMPOSE_FILE up -d $NEW_C; then
    echo "❌ Container failed to start"
    exit 1
fi

echo "Waiting for container to stabilize..."
sleep 15

echo "Checking container status..."

# Check if container is RUNNING
if ! sudo docker ps --filter name=$NEW_C --format "{{.Names}}" | grep -q $NEW_C; then
    echo "❌ Container is not running"
    sudo docker logs $NEW_C || true
    exit 1
fi

echo "Running health check..."

HEALTH_OK=0

for i in {1..20}; do
    if sudo docker exec $NEW_C nginx -t >/dev/null 2>&1; then
        HEALTH_OK=1
        break
    fi
    sleep 2
done

if [ "$HEALTH_OK" -ne 1 ]; then
    echo "❌ NEW container failed health check"

    sudo docker rm -f $NEW_C || true

    if [ -n "$ACTIVE_C" ]; then
        echo "Rolling back to $ACTIVE"
        sudo docker-compose -f $COMPOSE_FILE up -d $ACTIVE_C || true
    fi

    exit 1
fi

echo "✅ New container healthy"

if [ -n "$ACTIVE_C" ]; then
    sudo docker rm -f $ACTIVE_C || true
fi

echo "===== DEPLOY SUCCESS: $NEW ====="
