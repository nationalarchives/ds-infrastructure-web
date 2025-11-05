#!/bin/bash

# set environment variables
source /etc/environment

sudo touch /var/log/server-startup.log

region="eu-west-2"
if [ -z ${TRAEFIK_IMAGE+x} ]; then export TRAEFIK_IMAGE="none"; fi
if [ -z ${ENRICHMENT_APP_IMAGE+x} ]; then export ENRICHMENT_APP_IMAGE="none"; fi

# Install dependencies
sudo dnf -y update && sudo dnf install -y aws-cli jq

AWS_REGION="eu-west-2"
PARAMETER_PATH="/application/web/enrichment"

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

OUTPUT_FILE="/var/docker/enrichment.env"
sudo touch "$OUTPUT_FILE"
sudo chmod 777 "$OUTPUT_FILE"
> "$OUTPUT_FILE"

# Loop over each parameter and handle it correctly
echo "$PARAMS_JSON" | jq -c '.[]' | while read -r PARAMETER; do
    NAME=$(echo "$PARAMETER" | jq -r '.Name | split("/")[-1]')
    VALUE=$(echo "$PARAMETER" | jq -r '.Value')

    # Handle special cases (like docker_images with JSON format)
    if [[ "$NAME" == "docker_images" ]]; then
        # Escape quotes inside docker_images string properly
        ESCAPED_VALUE=$(echo "$VALUE" | sed 's/"/\\"/g')
        export "$NAME"="$ESCAPED_VALUE"
        echo "$NAME=\"$ESCAPED_VALUE\"" >> "$OUTPUT_FILE"
    else
        # For regular variables or variables containing special characters
        if [[ "$VALUE" == *","* ]] || [[ "$VALUE" == *":"* ]] || [[ "$VALUE" == *"/"* ]] || [[ "$VALUE" == *"\""* ]]; then
            # Wrap the value in quotes to handle special characters properly
            export "$NAME"="$VALUE"
            echo "$NAME=\"$VALUE\"" >> "$OUTPUT_FILE"
        else
            export "$NAME"="$VALUE"
            echo "$NAME=$VALUE" >> "$OUTPUT_FILE"
        fi
    fi
done

echo "Environment variables have been written to $OUTPUT_FILE."
# get docker image tag from parameter store
echo "retrieve versions"
exp_traefik_image=$(aws ssm get-parameter --name /application/web/enrichment/docker_images --query Parameter.Value --region $region --output text | jq -r '.["traefik"]')
exp_app_image=$(aws ssm get-parameter --name /application/web/enrichment/docker_images --query Parameter.Value --region $region --output text | jq -r '.["enrichment-application"]')

set_traefik_image=$(yq '.services.traefik.image' /var/docker/compose.traefik.yml)
set_app_image=$(yq '.services.blue-web.image' /var/docker/compose.yml)

sudo docker pull "$exp_app_image"
# update traefik version if needed
if [ "$TRAEFIK_IMAGE" != "$exp_traefik_image" ] || [ "$set_traefik_image" != "$exp_traefik_image" ]; then
  sudo yq -i ".services.traefik.image = \"$exp_traefik_image\"" /var/docker/compose.traefik.yml
  export TRAEFIK_IMAGE="$exp_traefik_image"
  sudo sed -i "s|export TRAEFIK_IMAGE=.*|export TRAEFIK_IMAGE=\"$exp_traefik_image\"|g" /etc/environment
fi

# check if traefik is running...
TRAEFIK_ID=$(sudo docker ps --all --filter "name=traefik" --format "{{.ID}}")
TRAEFIK_UP=$(sudo docker inspect -f '{{.State.Running}}' traefik 2> /dev/null)

if [ -z "$TRAEFIK_ID" ]; then
  # traefik container isn't loaded
  echo "starting up traefik - $exp_traefik_image"
  source /usr/local/bin/traefik-deploy.sh --up
  export TRAEFIK_IMAGE="$exp_traefik_image"
  echo "traefik image version set to $exp_traefik_image"
elif [ ! -z "$TRAEFIK_ID" ] && [ "$TRAEFIK_UP" != "true" ]; then
  # traefik is in a exit state
  echo "traefik has exited - try to restart"
  source /usr/local/bin/traefik-deploy.sh --restart
elif [ "$update_traefik" == "yes" ]; then
  echo "updating traefik to $exp_traefik_image ..."
  source /usr/local/bin/traefik-deploy.sh --down
  source /usr/local/bin/traefik-deploy.sh --up
  export TRAEFIK_IMAGE="$exp_traefik_image"
  echo "traefik image version set to $exp_traefik_image"
else
  echo "traefik is ok - tag:$exp_traefik_image"
fi

# update app version
if [ "$ENRICHMENT_APP_IMAGE" != "$exp_app_image" ] || [ "$set_app_image" != "$exp_app_image" ]; then
  sudo yq -i ".services.blue-web.image = \"$exp_app_image\"" /var/docker/compose.yml
  export ENRICHMENT_APP_IMAGE="$exp_app_image"
  sudo sed -i "s|export ENRICHMENT_APP_IMAGE=.*|export ENRICHMENT_APP_IMAGE=\"$exp_app_image\"|g" /etc/environment
fi

TRAEFIK_UP=$(sudo docker inspect -f '{{.State.Running}}' traefik 2> /dev/null)
if [ "$TRAEFIK_UP" = "true" ]; then
  sudo /usr/local/bin/website-blue-green-deploy.sh
  echo "startup completed"
else
  echo "can't start app - traefik hasn't started"
fi
