#!/usr/bin/env bash
set -e
region="eu-west-2"

echo "retrieve version"
exp_front_app_image=$(aws ssm get-parameter --name /application/web/frontend/docker_images --query Parameter.Value --region $region --output text | jq -r '.["frontend-application"]')

CID=$(sudo docker ps | grep $exp_front_app_image | awk '{print $1}')
sudo docker pull $exp_front_app_image

for im in $CID
do
    LATEST=`sudo docker inspect --format "{{.Id}}" $exp_front_app_image`
    RUNNING=`sudo docker inspect --format "{{.Image}}" $im`
    NAME=`sudo docker inspect --format '{{.Name}}' $im | sed "s/\///g"`
    echo "Latest:" $LATEST
    echo "Running:" $RUNNING
    if [ "$RUNNING" != "$LATEST" ];then
        echo "upgrading $NAME"
        stop docker-$NAME
        docker rm -f $NAME
        start docker-$NAME
    else
        echo "$NAME up to date"
    fi
done
