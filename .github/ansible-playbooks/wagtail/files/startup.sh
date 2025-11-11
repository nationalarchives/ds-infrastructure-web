#!/bin/bash
sudo /usr/local/bin/traefik-up.sh

# Set environment variables
source /etc/environment

sudo touch /var/log/server-startup.log

region="eu-west-2"
if [ -z ${TRAEFIK_IMAGE+x} ]; then export TRAEFIK_IMAGE="none"; fi
if [ -z ${WAGTAIL_APP_IMAGE+x} ]; then export WAGTAIL_APP_IMAGE="none"; fi

# Install dependencies
sudo dnf -y update && sudo dnf install -y aws-cli jq

AWS_REGION="eu-west-2"
PARAMETER_PATH="/application/web/wagtail"

# Fetch parameters from SSM
PARAMS_JSON=$(aws ssm get-parameters-by-path \
    --path "$PARAMETER_PATH" \
    --with-decryption \
    --region "$AWS_REGION" \
    --query "Parameters")

if [ -z "$PARAMS_JSON" ]; then
  echo "Error: No parameters found under the path $PARAMETER_PATH or insufficient permissions."
  exit 1
fi

OUTPUT_FILE="/var/docker/wagtail.env"
sudo touch "$OUTPUT_FILE"
sudo chmod 777 "$OUTPUT_FILE"
> "$OUTPUT_FILE"

# Loop over each parameter and handle it correctly
echo "$PARAMS_JSON" | jq -c '.[]' | while read -r PARAMETER; do
    NAME=$(echo "$PARAMETER" | jq -r '.Name | split("/")[-1]')
    VALUE=$(echo "$PARAMETER" | jq -r '.Value')

    # Handle special cases (like docker_images with JSON format)
    if [[ "$NAME" == "docker_images" ]]; then
        ESCAPED_VALUE=$(echo "$VALUE" | sed 's/"/\\"/g')
        #echo "Exporting $NAME=\"$ESCAPED_VALUE\""
        export "$NAME"="$ESCAPED_VALUE"
        echo "$NAME=\"$ESCAPED_VALUE\"" >> "$OUTPUT_FILE"
    else
        if [[ "$VALUE" == *","* ]] || [[ "$VALUE" == *":"* ]] || [[ "$VALUE" == *"/"* ]] || [[ "$VALUE" == *"\""* ]]; then
            #echo "Exporting $NAME=\"$VALUE\""
            export "$NAME"="$VALUE"
            echo "$NAME=\"$VALUE\"" >> "$OUTPUT_FILE"
        else
            #echo "Exporting $NAME=$VALUE"
            export "$NAME"="$VALUE"
            echo "$NAME=$VALUE" >> "$OUTPUT_FILE"
        fi
    fi
done

echo "Environment variables have been written to $OUTPUT_FILE."
# get docker image tag from parameter store
echo "retrieve versions"
exp_traefik_image=$(aws ssm get-parameter --name /application/web/wagtail/docker_images --query Parameter.Value --region $region --output text | jq -r '.["traefik"]')
exp_app_image=$(aws ssm get-parameter --name /application/web/wagtail/docker_images --query Parameter.Value --region $region --output text | jq -r '.["wagtail-application"]')

set_traefik_image=$(yq '.services.traefik.image' /var/docker/compose.traefik.yml)
set_app_image=$(yq '.services.blue-web.image' /var/docker/compose.yml)

# update traefik version if needed
if [ "$TRAEFIK_IMAGE" != "$exp_traefik_image" ] || [ "$set_traefik_image" != "$exp_traefik_image" ]; then
  sudo yq -i ".services.traefik.image = \"$exp_traefik_image\"" /var/docker/compose.traefik.yml
  export TRAEFIK_IMAGE="$exp_traefik_image"
  sudo sed -i "s|export TRAEFIK_IMAGE=.*|export TRAEFIK_IMAGE=\"$exp_traefik_image\"|g" /etc/environment
fi
sudo docker pull "$exp_app_image"
# update app version
if [ "$WAGTAIL_APP_IMAGE" != "$exp_app_image" ] || [ "$set_app_image" != "$exp_app_image" ]; then
  sudo yq -i ".services.blue-web.image = \"$exp_app_image\"" /var/docker/compose.yml
  export WAGTAIL_APP_IMAGE="$exp_app_image"
  sudo sed -i "s|export WAGTAIL_APP_IMAGE=.*|export WAGTAIL_APP_IMAGE=\"$exp_app_image\"|g" /etc/environment
fi

# Continue with the deployment process
TRAEFIK_UP=$(sudo docker inspect -f '{{.State.Running}}' traefik 2> /dev/null)
if [ "$TRAEFIK_UP" = "true" ]; then
  sudo /usr/local/bin/website-blue-green-deploy.sh

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
