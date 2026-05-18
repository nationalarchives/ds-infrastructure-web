#!/bin/bash

set -e

source /etc/environment

sudo touch /var/log/server-startup.log

region="eu-west-2"

# Install dependencies
sudo dnf -y update && sudo dnf install -y aws-cli jq yq

# Fetch images from SSM
ssm_data=$(aws ssm get-parameter \
  --name /application/nginx/docker-images \
  --region "$region" \
  --query Parameter.Value \
  --output text)

TRAEFIK_IMAGE=$(echo "$ssm_data" | jq -r '.traefik')
NGINX_APP_IMAGE=$(echo "$ssm_data" | jq -r '.["nginx-application"]')


if [[ -z "$TRAEFIK_IMAGE" || "$TRAEFIK_IMAGE" == "none" ]]; then
  echo "ERROR: Invalid TRAEFIK_IMAGE"
  exit 1
fi

if [[ -z "$NGINX_APP_IMAGE" || "$NGINX_APP_IMAGE" == "none" ]]; then
  echo "ERROR: Invalid NGINX_APP_IMAGE"
  exit 1
fi

echo "Using TRAEFIK_IMAGE=$TRAEFIK_IMAGE"
echo "Using NGINX_APP_IMAGE=$NGINX_APP_IMAGE"

# Get current compose values
set_traefik_image=$(yq '.services.traefik.image' /var/docker/compose.traefik.yml)
set_app_image=$(yq '.services.blue-web.image' /var/docker/compose.yml)

# Update Traefik if changed
if [ "$TRAEFIK_IMAGE" != "$set_traefik_image" ]; then
    sudo yq -i ".services.traefik.image = \"$TRAEFIK_IMAGE\"" /var/docker/compose.traefik.yml
fi

# Ensure Traefik running
if ! sudo docker ps --format '{{.Names}}' | grep -q "traefik"; then
    echo "Starting Traefik container..."
    sudo /usr/local/bin/traefik-deploy.sh --up
fi

# Update app image ONLY if changed
if [ "$NGINX_APP_IMAGE" != "$set_app_image" ]; then
    echo "Updating application image..."

    sudo yq -i ".services.blue-web.image = \"$NGINX_APP_IMAGE\"" /var/docker/compose.yml
    sudo yq -i ".services.green-web.image = \"$NGINX_APP_IMAGE\"" /var/docker/compose.yml
fi

if sudo docker ps | grep -q traefik; then
    sudo /usr/local/bin/website-blue-green-deploy.sh
    echo "Startup completed successfully."
else
    echo "can't start app - traefik hasn't started"
    exit 1
fi
