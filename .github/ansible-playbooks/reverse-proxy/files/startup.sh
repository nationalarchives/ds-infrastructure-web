#!/bin/bash

set -e

COMPOSE_FILE="/var/docker/compose.yml"

BLUE="blue-web"
GREEN="green-web"

echo "======================================"
echo "Starting Nginx Blue-Green Deployment"
echo "======================================"

# detect running containers
BLUE_RUNNING=$(sudo docker ps --filter "name=$BLUE" --format "{{.Names}}")
GREEN_RUNNING=$(sudo docker ps --filter "name=$GREEN" --format "{{.Names}}")

echo "Blue running: $BLUE_RUNNING"
echo "Green running: $GREEN_RUNNING"

# determine active and new
if [ -z "$BLUE_RUNNING" ] && [ -z "$GREEN_RUNNING" ]; then
    echo "No containers running. Starting fresh with blue..."
    ACTIVE=""
    NEW="blue"

elif [ -n "$BLUE_RUNNING" ]; then
    ACTIVE="blue"
    NEW="green"

else
    ACTIVE="green"
    NEW="blue"
fi

# set container names
if [ -n "$ACTIVE" ]; then
    ACTIVE_CONTAINER="${ACTIVE}-web"
else
    ACTIVE_CONTAINER=""
fi

NEW_CONTAINER="${NEW}-web"

echo "======================================"
echo "Switching from ${ACTIVE:-none} to $NEW"
echo "======================================"

echo "Active: ${ACTIVE_CONTAINER:-none}"
echo "Starting: $NEW_CONTAINER"

# detect docker compose command
if docker-compose version >/dev/null 2>&1; then
    DC="docker-compose"
else
    DC="docker compose"
fi

echo "Using: $DC"

# start new container
sudo $DC -f $COMPOSE_FILE up -d $NEW_CONTAINER

echo "Waiting for container..."
sleep 10

# check container status
STATUS=$(sudo docker inspect -f '{{.State.Running}}' $NEW_CONTAINER 2>/dev/null || echo "false")

if [ "$STATUS" != "true" ]; then
    echo "❌ Container failed to start"

    if [ -n "$ACTIVE_CONTAINER" ]; then
        sudo $DC -f $COMPOSE_FILE up -d $ACTIVE_CONTAINER
    fi

    exit 1
fi

# test nginx config
echo "Testing nginx config..."
sudo docker exec $NEW_CONTAINER nginx -t

if [ $? -ne 0 ]; then
    echo "❌ Nginx config failed! Rolling back..."

    if [ -n "$ACTIVE_CONTAINER" ]; then
        sudo $DC -f $COMPOSE_FILE up -d $ACTIVE_CONTAINER
    fi

    sudo docker rm -f $NEW_CONTAINER || true
    exit 1
fi

# stop old container if exists
echo "Stopping old container..."

if [ -n "$ACTIVE_CONTAINER" ]; then
    sudo docker stop $ACTIVE_CONTAINER || true
    sudo docker rm -f $ACTIVE_CONTAINER || true
fi

echo "======================================"
echo "✅ Switched to $NEW"
echo "======================================"
