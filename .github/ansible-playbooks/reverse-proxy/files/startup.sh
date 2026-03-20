#!/bin/bash

# set environment variables
source /etc/environment

sudo touch /var/log/server-startup.log

region="eu-west-2"

if [ -z ${TRAEFIK_IMAGE+x} ]; then export TRAEFIK_IMAGE="none"; fi
if [ -z ${NGINX_APP_IMAGE+x} ]; then export NGINX_APP_IMAGE="none"; fi

# get docker image tag from parameter store
echo "retrieve versions"
exp_traefik_image=$(aws ssm get-parameter --name /application/nginx/docker-images --query Parameter.Value --region $region --output text | jq -r '.["traefik"]')
exp_app_image=$(aws ssm get-parameter --name /application/nginx/docker-images --query Parameter.Value --region $region --output text | jq -r '.["nginx-application"]')

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

# update app version
if [ "$NGINX_APP_IMAGE" != "$exp_app_image" ] || [ "$set_app_image" != "$exp_app_image" ]; then
  sudo yq -i ".services.blue-web.image = \"$exp_app_image\"" /var/docker/compose.yml
  export NGINX_APP_IMAGE="$exp_app_image"
  sudo sed -i "s|export NGINX_APP_IMAGE=.*|export NGINX_APP_IMAGE=\"$exp_app_image\"|g" /etc/environment
fi

TRAEFIK_UP=$(sudo docker inspect -f '{{.State.Running}}' traefik 2> /dev/null)
if [ "$TRAEFIK_UP" = "true" ]; then
  sudo /usr/local/bin/website-blue-green-deploy.sh
else
  echo "can't start app - traefik hasn't started"
fi