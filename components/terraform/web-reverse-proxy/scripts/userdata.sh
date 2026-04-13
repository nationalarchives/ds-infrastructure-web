#!/bin/bash

# Update yum
sudo yum update -y

# Mount EFS (Wagtail Media)
sudo mkdir -p ${web_wagtail_efs_mount_dir}
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${mount_target}:/ ${web_wagtail_efs_mount_dir}
sudo chmod 777 ${web_wagtail_efs_mount_dir}
sudo echo "${mount_target}:/ ${web_wagtail_efs_mount_dir} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,fsc,_netdev 0 0" >> /etc/fstab

# Install Docker
echo "Installing Docker..."
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker

echo "Creating /etc/nginx directory..."
sudo mkdir -p /etc/nginx
sudo aws s3 cp \
s3://${deployment_s3_bucket}/${service}/${nginx_folder_s3_key}/v1/ \
/etc/nginx/ \
--recursive \
--exclude "*" \
--include "*.conf" \
--include "mime.types"

echo "Listing copied files:"
ls -l /etc/nginx || true

# Reload Nginx container (zero downtime)
echo "Waiting for Nginx container to start..."
max_retries=12
count=0
until docker ps --format '{{.Names}}' | grep -q "^nginx$"; do
    count=$((count+1))
    if [ "$count" -ge "$max_retries" ]; then
        echo "Nginx container not found after waiting. Skipping reload."
        break
    fi
    echo "Waiting for container... retry $count/$max_retries"
    sleep 5
done

if docker ps --format '{{.Names}}' | grep -q "^nginx$"; then
    echo "Reloading Nginx inside container..."
    docker exec nginx nginx -s reload
else
    echo "Nginx container is not running. Skipping reload."
fi

# Install CodeDeploy Agent
echo "Installing CodeDeploy Agent..."
CODEDEPLOY_BIN="/opt/codedeploy-agent/bin/codedeploy-agent"
if [ -f "$CODEDEPLOY_BIN" ]; then
    sudo $CODEDEPLOY_BIN stop
    sudo yum erase codedeploy-agent -y
fi

sudo yum install -y ruby wget unzip
sudo wget https://aws-codedeploy-eu-west-2.s3.eu-west-2.amazonaws.com/latest/install -O /tmp/install_codedeploy
sudo chmod +x /tmp/install_codedeploy
sudo /tmp/install_codedeploy auto

echo "Userdata script completed successfully."
