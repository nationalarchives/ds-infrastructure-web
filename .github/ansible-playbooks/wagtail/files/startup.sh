#!/bin/bash

# Set environment variables
source /etc/environment

sudo touch /var/log/server-startup.log

region="eu-west-2"
AWS_REGION="eu-west-2"
PARAMETER_PATH="/application/web/wagtail"
if [ -z ${TRAEFIK_IMAGE+x} ]; then export TRAEFIK_IMAGE="none"; fi
if [ -z ${WAGTAIL_APP_IMAGE+x} ]; then export WAGTAIL_APP_IMAGE="none"; fi

# Install dependencies
sudo dnf -y update && sudo dnf install -y aws-cli jq

OUTPUT_FILE="/var/docker/wagtail.env"
sudo touch "$OUTPUT_FILE"
sudo chmod 777 "$OUTPUT_FILE"
> "$OUTPUT_FILE"

echo "Generating .env file from SSM parameters..."

# Fetch main JSON parameter
MAIN_JSON=$(aws ssm get-parameter \
    --name "$PARAMETER_PATH" \
    --with-decryption \
    --region "$AWS_REGION" \
    --query "Parameter.Value" \
    --output text)

while IFS=$'\t' read -r key value; do
    printf '%s="%s"\n' "$key" "$value" >> "$OUTPUT_FILE"
done < <(jq -r 'to_entries[] | [.key, .value] | @tsv' <<< "$MAIN_JSON")

# Fetch other individual parameters
PARAM_NAMES=$(aws ssm get-parameters-by-path \
    --path "$PARAMETER_PATH" \
    --with-decryption \
    --region "$AWS_REGION" \
    --query "Parameters[].Name" \
    --output text)

for full_name in $PARAM_NAMES; do
    if [ "$full_name" == "$PARAMETER_PATH" ]; then
        continue
    fi

    key=$(basename "$full_name")

    # Special handling for docker_images JSON
    if [ "$key" == "docker_images" ]; then
        docker_json=$(aws ssm get-parameter \
            --name "$full_name" \
            --with-decryption \
            --region "$AWS_REGION" \
            --query "Parameter.Value" \
            --output text)
        
        WAGTAIL_APP_IMAGE=$(echo "$docker_json" | jq -r '.["wagtail-application"]')
        TRAEFIK_IMAGE=$(echo "$docker_json" | jq -r '.["traefik"]')

        printf 'DOCKER_IMAGE_WAGTAIL_APPLICATION="%s"\n' "$WAGTAIL_APP_IMAGE" >> "$OUTPUT_FILE"
        printf 'DOCKER_IMAGE_TRAEFIK="%s"\n' "$TRAEFIK_IMAGE" >> "$OUTPUT_FILE"
        continue
    fi

    value=$(aws ssm get-parameter \
        --name "$full_name" \
        --with-decryption \
        --region "$AWS_REGION" \
        --query "Parameter.Value" \
        --output text)

    printf '%s="%s"\n' "$key" "$value" >> "$OUTPUT_FILE"
done

echo "Environment variables have been written to $OUTPUT_FILE."

echo "Retrieving Docker images..."

# Pull the image
sudo docker pull "$WAGTAIL_APP_IMAGE"

# Get currently set images in compose files

set_traefik_image=$(yq '.services.traefik.image' /var/docker/compose.traefik.yml)
set_app_image=$(yq '.services.blue-web.image' /var/docker/compose.yml)

# Update traefik version if needed
if [ "$TRAEFIK_IMAGE" != "$set_traefik_image" ]; then
  sudo yq -i ".services.traefik.image = \"$TRAEFIK_IMAGE\"" /var/docker/compose.traefik.yml
  sudo sed -i "s|export TRAEFIK_IMAGE=.*|export TRAEFIK_IMAGE=\"$TRAEFIK_IMAGE\"|g" /etc/environment
fi

# Check if traefik is running...
TRAEFIK_ID=$(sudo docker ps --all --filter "name=traefik" --format "{{.ID}}")
TRAEFIK_UP=$(sudo docker inspect -f '{{.State.Running}}' traefik 2> /dev/null)

if [ -z "$TRAEFIK_ID" ]; then
    echo "Starting Traefik container..."
    source /usr/local/bin/traefik-deploy.sh --up
elif [ "$TRAEFIK_UP" != "true" ]; then
    echo "Traefik has exited - restarting..."
    source /usr/local/bin/traefik-deploy.sh --restart
else
    echo "Traefik is running - tag:$TRAEFIK_IMAGE"
fi

# Update app version
if [ "$WAGTAIL_APP_IMAGE" != "$set_app_image" ]; then
  sudo yq -i ".services.blue-web.image = \"$WAGTAIL_APP_IMAGE\"" /var/docker/compose.yml  
  sudo sed -i "s|export WAGTAIL_APP_IMAGE=.*|export WAGTAIL_APP_IMAGE=\"$WAGTAIL_APP_IMAGE\"|g" /etc/environment
fi

# Blue-green deployment
TRAEFIK_UP=$(sudo docker inspect -f '{{.State.Running}}' traefik 2> /dev/null)
if [ "$TRAEFIK_UP" = "true" ]; then
  sudo /usr/local/bin/website-blue-green-deploy.sh
  echo "Startup completed successfully."

  CLOUDFRONT_DIST_ID=$(aws ssm get-parameter \
    --name "/application/web/wagtail/FRONTEND_CACHE_AWS_DISTRIBUTION_ID" \
    --with-decryption \
    --region "$AWS_REGION" \
    --query "Parameter.Value" \
    --output text)

  if [ -z "$CLOUDFRONT_DIST_ID" ]; then
    echo "❌ Error: Could not fetch CloudFront Distribution ID from SSM."
    exit 1
  fi

  echo "Invalidating CloudFront cache for distribution $CLOUDFRONT_DIST_ID ..."
  aws cloudfront create-invalidation \
    --distribution-id "$CLOUDFRONT_DIST_ID" \
    --paths "/*"

  echo "Deployment and cache invalidation complete."
else
  echo "Can't start app - traefik hasn't started"
  exit 1
fi

# Identify which web container is running (green-web or blue-web)
RUNNING_WEB=$(sudo docker ps --filter "name=green-web" --filter "status=running" --format "{{.Names}}" | grep green-web || true)

if [ -z "$RUNNING_WEB" ]; then
  RUNNING_WEB=$(sudo docker ps --filter "name=blue-web" --filter "status=running" --format "{{.Names}}" | grep blue-web || true)
fi

# Create or overwrite migrate.log before running migrations
if [ ! -f /var/log/migrate.log ]; then
    sudo touch /var/log/migrate.log
    sudo chmod 666 /var/log/migrate.log
else
    sudo bash -c '> /var/log/migrate.log'
fi

# Run migrate inside the running container, output to migrate.log
if [ -n "$RUNNING_WEB" ]; then
  echo "Running migration in container: $RUNNING_WEB"
  sudo docker exec "$RUNNING_WEB" poetry run python /app/manage.py migrate > /var/log/migrate.log 2>&1
else
  echo "Error: Neither green-web nor blue-web is running."
  exit 1
fi
