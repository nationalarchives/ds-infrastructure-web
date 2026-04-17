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

# Nginx config from S3
sudo aws s3 cp \
s3://${deployment_s3_bucket}/${service}/${nginx_folder_s3_key}/ \
/etc/nginx/ \
--recursive \
--exclude "*" \
--include "*.conf" \
--include "mime.types"

ln -sfn /etc/nginx/v1 /etc/nginx/current

# Build image
if ! docker image inspect custom-nginx:latest >/dev/null 2>&1; then
  echo "Building nginx image..."
  cd /var/docker
  docker build -t custom-nginx:latest .
else
  echo "Image already exists, skipping build"
fi

# startup script
sudo touch /var/log/start-up.log
echo "$(date '+%Y-%m-%d %T') - system update" | sudo tee -a /var/log/start-up.log > /dev/null
echo "$(date '+%Y-%m-%d %T') - call startup script" | sudo tee -a /var/log/start-up.log > /dev/null
/usr/local/bin/startup.sh

# Reload Nginx container (zero downtime)
echo "Waiting for Nginx container to start..."
max_retries=12
count=0
until docker ps --format '{{.Names}}' | grep -E "blue-web|green-web" >/dev/null; do
  count=$((count+1))
  if [ "$count" -ge "$max_retries" ]; then
    echo "Containers not found after waiting. Skipping reload."
    break
  fi
  echo "Waiting... retry $count/$max_retries"
  sleep 5
done

echo "Reloading nginx inside active containers..."

for c in blue-web green-web; do
  if docker ps --format '{{.Names}}' | grep -q "^$c$"; then
    echo "Reloading $c"
    docker exec $c nginx -s reload || true
  fi
done

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
