#!/bin/bash

# set environment variables
source /etc/environment

sudo touch /var/log/server-startup.log

region="eu-west-2"
if [ -z ${TRAEFIK_IMAGE+x} ]; then export TRAEFIK_IMAGE="none"; fi
if [ -z ${FRONTEND_APP_IMAGE+x} ]; then export FRONTEND_APP_IMAGE="none"; fi


# get docker image tag from parameter store
echo "retrieve versions"
exp_traefik_image=$(aws ssm get-parameter --name /application/web/frontend/docker_images --query Parameter.Value --region $region --output text | jq -r '.["traefik"]')
exp_front_app_image=$(aws ssm get-parameter --name /application/web/frontend/docker_images --query Parameter.Value --region $region --output text | jq -r '.["frontend-application"]')

# update compose.traefik.yml if needed
if [ "$TRAEFIK_IMAGE" != "$exp_traefik_image" ]; then
  sudo yq -i ".services.traefik.image = \"$exp_traefik_image\"" /var/docker/compose.traefik.yml
  sudo sed -i "s|export TRAEFIK_IMAGE=.*|export TRAEFIK_IMAGE=$exp_traefik_image|g" /etc/environment
  update_traefik="yes"
  echo "traefik image updating to $exp_traefik_image"
else
  update_traefik="no"
fi

# check if traefik is running...
TRAEFIK_ID=$(sudo docker ps --all --filter "name=traefik" --format "{{.ID}}")
if [ -z "$TRAEFIK_ID" ]; then
  # traefik isn't running
  echo "starting up traefik - $exp_traefik_image"
  source /usr/local/bin/traefik-run.sh
  export TRAEFIK_IMAGE="$exp_traefik_image"
  echo "traefik image version set to $exp_traefik_image"
elif [ $update_traefik = "yes" ]; then
  echo "updating traefik to $exp_traefik_image ..."
  source /usr/local/bin/traefik-run.sh
  export TRAEFIK_IMAGE="$exp_traefik_image"
  echo "traefik image version set to $exp_traefik_image"
else
  echo "traefik is ok - tag:$exp_traefik_image"
fi

# update compose.yml if needed
if [ "$FRONTEND_APP_IMAGE" != "$exp_front_app_image" ]; then
  sudo yq -i ".services.blue-web.image = \"$exp_front_app_image\"" /var/docker/compose.yml
  sudo sed -i "s|export FRONTEND_APP_IMAGE=.*|export FRONTEND_APP_IMAGE=$exp_front_app_image|g" /etc/environment
  update_website="yes"
  echo "website needs updating to $exp_front_app_image"
else
  update_website="no"
fi

# check if website is running...
BLUE_ID=$(sudo docker ps --filter "name=blue-frontend" --format "{{.ID}}")
GREEN_ID=$(sudo docker ps --filter "name=green-frontend" --format "{{.ID}}")
if [ -z "$BLUE_ID" ] && [ -z "$GREEN_ID" ]; then
  # website isn't running
  echo "starting up website - $exp_front_app_image"
  source /usr/local/bin/website-blue-green-deploy.sh
  echo "webserver image version set to $exp_front_app_image"
elif [ $update_website = "yes" ]; then
  echo "updating website to $exp_front_app_image ..."
  source /usr/local/bin/website-blue-green-deploy.sh
  echo "webserver image version set to $exp_front_app_image"
else
  echo "website is ok - tag:$exp_front_app_image"
fi

source /etc/environment
