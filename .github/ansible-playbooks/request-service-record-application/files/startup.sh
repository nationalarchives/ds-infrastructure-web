#!/bin/bash

# set environment variables
source /etc/environment
sudo touch /var/log/server-startup.log
region="eu-west-2"

if [ -z ${TRAEFIK_IMAGE+x} ]; then export TRAEFIK_IMAGE="none"; fi
if [ -z ${FRONTEND_APP_IMAGE+x} ]; then export FRONTEND_APP_IMAGE="none"; fi

# Install dependencies
sudo dnf -y update && sudo dnf install -y aws-cli jq

AWS_REGION="eu-west-2"
PARAMETER_PATH="/application/web/requestservicerecord"

# Fetch parameters from SSM
PARAMS_JSON=$(aws ssm get-parameter \
    --name "$PARAMETER_PATH" \
    --region "$AWS_REGION" \
    --query "Parameter.Value" \
    --output text)

if [ -z "$PARAMS_JSON" ]; then
  echo "Error: No parameters found under the path $PARAMETER_PATH or insufficient permissions."
  exit 1
fi

OUTPUT_FILE="/var/docker/frontend.env"
sudo touch "$OUTPUT_FILE"
sudo chmod 777 "$OUTPUT_FILE"
> "$OUTPUT_FILE"

while IFS=$'\t' read -r raw_key raw_value; do
    printf '%s="%s"\n' "$raw_key" "$raw_value" >> "$OUTPUT_FILE"
done < <(jq -r 'to_entries[] | [.key, .value] | @tsv' <<< "$PARAMS_JSON")

## Loop over each parameter and handle it correctly
#echo "$PARAMS_JSON" | jq -c '.[]' | while read -r PARAMETER; do
#    NAME=$(echo "$PARAMETER" | jq -r '.Name | split("/")[-1]')
#    VALUE=$(echo "$PARAMETER" | jq -r '.Value')
#
#    # Handle special cases (like docker_images with JSON format)
#    if [[ "$NAME" == "docker_images" ]]; then
#        ESCAPED_VALUE=$(echo "$VALUE" | sed 's/"/\\"/g')
#        #echo "Exporting $NAME=\"$ESCAPED_VALUE\""
#        export "$NAME"="$ESCAPED_VALUE"
#        echo "$NAME=\"$ESCAPED_VALUE\"" >> "$OUTPUT_FILE"
#    else
#        if [[ "$VALUE" == *","* ]] || [[ "$VALUE" == *":"* ]] || [[ "$VALUE" == *"/"* ]] || [[ "$VALUE" == *"\""* ]]; then
#            #echo "Exporting $NAME=\"$VALUE\""
#            export "$NAME"="$VALUE"
#            echo "$NAME=\"$VALUE\"" >> "$OUTPUT_FILE"
#        else
#            #echo "Exporting $NAME=$VALUE"
#            export "$NAME"="$VALUE"
#            echo "$NAME=$VALUE" >> "$OUTPUT_FILE"
#        fi
#    fi
#done

echo "Environment variables have been written to $OUTPUT_FILE."
# get docker image tag from parameter store
echo "retrieve versions"
exp_traefik_image=$(aws ssm get-parameter --name /application/web/request-service-record/docker_images --query Parameter.Value --region $region --output text | jq -r '.["traefik"]')
exp_app_image=$(aws ssm get-parameter --name /application/web/request-service-record/docker_images --query Parameter.Value --region $region --output text | jq -r '.["frontend-application"]')

set_traefik_image=$(yq '.services.traefik.image' /var/docker/compose.traefik.yml)
set_app_image=$(yq '.services.blue-web.image' /var/docker/compose.yml)

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
sudo docker pull "$exp_app_image"
# update app version
if [ "$FRONTEND_APP_IMAGE" != "$exp_app_image" ] || [ "$set_app_image" != "$exp_app_image" ]; then
  sudo yq -i ".services.blue-web.image = \"$exp_app_image\"" /var/docker/compose.yml
  export FRONTEND_APP_IMAGE="$exp_app_image"
  sudo sed -i "s|export FRONTEND_APP_IMAGE=.*|export FRONTEND_APP_IMAGE=\"$exp_app_image\"|g" /etc/environment
fi

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
  echo "can't start app - traefik hasn't started"
fi
