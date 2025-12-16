#!/bin/bash

# set environment variables
source /etc/environment

sudo touch /var/log/server-startup.log

region="eu-west-2"
AWS_REGION="eu-west-2"
PARAMETER_PATH="/application/web/requestservicerecord"

if [ -z ${TRAEFIK_IMAGE+x} ]; then export TRAEFIK_IMAGE="none"; fi
if [ -z ${REQUESTSERVICERECORD_APP_IMAGE+x} ]; then export REQUESTSERVICERECORD_APP_IMAGE="none"; fi

# Install dependencies
sudo dnf -y update && sudo dnf install -y aws-cli jq

OUTPUT_FILE="/var/docker/requestservicerecord.env"
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
        
        REQUESTSERVICERECORD_APP_IMAGE=$(echo "$docker_json" | jq -r '.["requestservicerecord-application"]')
        TRAEFIK_IMAGE=$(echo "$docker_json" | jq -r '.["traefik"]')

        printf 'DOCKER_IMAGE_REQUESTSERVICERECORD_APPLICATION="%s"\n' "$REQUESTSERVICERECORD_APP_IMAGE" >> "$OUTPUT_FILE"
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

echo "Environment variables have been written to $OUTPUT_FILE"

echo "Retrieving Docker images..."

# Pull the image
sudo docker pull "$REQUESTSERVICERECORD_APP_IMAGE"

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
if [ "$REQUESTSERVICERECORD_APP_IMAGE" != "$set_app_image" ]; then
  sudo yq -i ".services.blue-web.image = \"$REQUESTSERVICERECORD_APP_IMAGE\"" /var/docker/compose.yml
  sudo sed -i "s|export REQUESTSERVICERECORD_APP_IMAGE=.*|export REQUESTSERVICERECORD_APP_IMAGE=\"$REQUESTSERVICERECORD_APP_IMAGE\"|g" /etc/environment
fi

# Blue-green deployment
TRAEFIK_UP=$(sudo docker inspect -f '{{.State.Running}}' traefik 2> /dev/null)
if [ "$TRAEFIK_UP" = "true" ]; then
    sudo /usr/local/bin/website-blue-green-deploy.sh
    echo "Startup completed successfully."
else
    echo "can't start app - traefik hasn't started"
fi
