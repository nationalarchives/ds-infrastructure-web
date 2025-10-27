#!/bin/bash

json_to_env_file() {
    local json_string="$1"        # JSON text
    local output_file="$2"        # e.g. ./app.env
    local prefix="${3:-}"         # optional prefix, e.g. APP_
    if [[ -z "$json_string" || -z "$output_file" ]]; then
        echo "Usage: json_to_env_file <json_string> <output_file> [PREFIX]" >&2
        return 1
    fi
    if ! command -v jq >/dev/null 2>&1; then
        echo "jq not found (install: brew install jq)" >&2
        return 1
    fi

    : > "$output_file" || return 1
    chmod 644 "$output_file" 2>/dev/null || true

    jq -r --arg p "$prefix" '
        paths(scalars) as $path |
        ($path | map(tostring)) as $parts |
        ($parts
        | map(gsub("[^A-Za-z0-9_]"; "_"))
        | map(sub("^([0-9])"; "_\\1"))
        | map(ascii_upcase)
        | join("_")
        ) as $base |
        ($p + $base) as $var |
        # Always shell-escape; yields safe single-quoted strings for non-numeric scalars
        "\($var)=\(getpath($path)|@sh)"
        ' <<<"$json_string" >> "$output_file"
}

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
  image_id=$(sudo docker image ls --quiet ghcr.io/nationalarchives/ds-request-service-record:$docker_image_tag)
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
    sudo docker rmi ghcr.io/nationalarchives/ds-request-service-record:$docker_image_tag
  else
    # dp  nothing
    echo "no image on system"
  fi

  # pull image
  sudo docker image pull ghcr.io/nationalarchives/ds-request-service-record:$docker_image_tag
  # get image id
  image_id=$(sudo docker image ls --quiet ghcr.io/nationalarchives/ds-request-service-record:$docker_image_tag)
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
