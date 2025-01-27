#!/bin/bash

# Install dependencies
sudo dnf -y update && sudo dnf install -y aws-cli jq

AWS_REGION="eu-west-2"
PARAMETER_PATH="/application/web/frontend"

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

OUTPUT_FILE="/var/docker/frontend.env"
sudo touch "$OUTPUT_FILE"
sudo chmod 600 "$OUTPUT_FILE"
> "$OUTPUT_FILE"

# Loop over each parameter and handle it correctly
echo "$PARAMS_JSON" | jq -c '.[]' | while read -r PARAMETER; do
    NAME=$(echo "$PARAMETER" | jq -r '.Name | split("/")[-1]')
    VALUE=$(echo "$PARAMETER" | jq -r '.Value')

    # Handle special cases (like docker_images with JSON format)
    if [[ "$NAME" == "docker_images" ]]; then
        # Escape quotes inside docker_images string properly
        ESCAPED_VALUE=$(echo "$VALUE" | sed 's/"/\\"/g')
        echo "Exporting $NAME=\"$ESCAPED_VALUE\""
        export "$NAME"="$ESCAPED_VALUE"
        echo "$NAME=\"$ESCAPED_VALUE\"" >> "$OUTPUT_FILE"
    else
        # For regular variables or variables containing special characters
        if [[ "$VALUE" == *","* ]] || [[ "$VALUE" == *":"* ]] || [[ "$VALUE" == *"/"* ]] || [[ "$VALUE" == *"\""* ]]; then
            # Wrap the value in quotes to handle special characters properly
            echo "Exporting $NAME=\"$VALUE\""
            export "$NAME"="$VALUE"
            echo "$NAME=\"$VALUE\"" >> "$OUTPUT_FILE"
        else
            # Normal variable, no need to quote
            echo "Exporting $NAME=$VALUE"
            export "$NAME"="$VALUE"
            echo "$NAME=$VALUE" >> "$OUTPUT_FILE"
        fi
    fi
done

echo "Environment variables have been written to $OUTPUT_FILE."
# update instance

while getopts t: flag
do
    case "${flag}" in
        t) docker_image_tag=${OPTARG};;
        *) exit;;
    esac
done

# check if variable is set
if [[ $docker_image_tag != "" ]]
then
  # read parameter store and secrets

  # create variable file for docker

  # running container with this tag

  # image exists already
  image_id=$(sudo docker image ls --quiet ghcr.io/nationalarchives/ds-wagtail:$docker_image_tag)
  if [[ $image_id != '' ]]
  then
    # check if container is running
    running_image=$(sudo docker ps --quiet --filter "ancestor=$image_id")
    if [[ $running_image != '' ]]
    then
      # stop container
      sudo docker stop $running_image --time 10
      sudo docker container rm $running_image
    fi
    # remove image
    sudo docker rmi ghcr.io/nationalarchives/ds-wagtail:$docker_image_tag
  else
    # dp  nothing
    echo "no image on system"
  fi

  # pull image
  sudo docker image pull ghcr.io/nationalarchives/ds-wagtail:$docker_image_tag
  # get image id
  image_id=$(sudo docker image ls --quiet ghcr.io/nationalarchives/ds-wagtail:$docker_image_tag)
  # run container
  sudo docker run --name django-wagtail $image_id
else
  # error
  echo "No tag given"
fi


if sudo docker ps --format "{{.Names}}" | grep -q "$BLUE_SERVICE"; then
  ACTIVE_SERVICE=$BLUE_SERVICE
  INACTIVE_SERVICE=$GREEN_SERVICE
elif sudo docker ps --format "{{.Names}}" | grep -q "$GREEN_SERVICE"; then
  ACTIVE_SERVICE=$GREEN_SERVICE
  INACTIVE_SERVICE=$BLUE_SERVICE
else
  ACTIVE_SERVICE=""
  INACTIVE_SERVICE=$BLUE_SERVICE
fi

echo "Starting $INACTIVE_SERVICE container"
sudo /usr/local/bin/docker-compose up --build --remove-orphans --detach $INACTIVE_SERVICE



echo "Waiting for $INACTIVE_SERVICE to become healthy..."
for ((i=1; i<=$MAX_RETRIES; i++)); do
  CONTAINER_IP=$(sudo docker inspect --format='{{range $key, $value := .NetworkSettings.Networks}}{{if eq $key "'"$TRAEFIK_NETWORK"'"}}{{$value.IPAddress}}{{end}}{{end}}' "$INACTIVE_SERVICE" || true)
  if [[ -z "$CONTAINER_IP" ]]; then
    # The docker inspect command failed, so sleep for a bit and retry
    sleep "$SLEEP_INTERVAL"
    continue
  fi

  HEALTH_CHECK_URL="http://$CONTAINER_IP:$SERVICE_PORT/health"
  # N.B.: We use docker to execute curl because on macOS we are unable to directly access the docker-managed Traefik network.
  if sudo docker run --net $TRAEFIK_NETWORK --rm curlimages/curl:8.00.1 --fail --silent "$HEALTH_CHECK_URL" >/dev/null; then
    echo "$INACTIVE_SERVICE is healthy"
    break
  fi

  sleep "$SLEEP_INTERVAL"
done

if ! sudo docker run --net $TRAEFIK_NETWORK --rm curlimages/curl:8.00.1 --fail --silent "$HEALTH_CHECK_URL" >/dev/null; then
  echo "$INACTIVE_SERVICE did not become healthy within $TIMEOUT seconds"
  sudo /usr/local/bin/docker-compose stop --timeout=30 $INACTIVE_SERVICE
  exit 1
fi
