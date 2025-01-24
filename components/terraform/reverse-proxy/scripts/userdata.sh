#!/bin/bash

# Update yum
sudo yum update -y

# Mount EFS storage
sudo mkdir -p ${mount_dir}
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${mount_target}:/ ${mount_dir}
sudo chmod 777 ${mount_dir}
cd ${mount_dir}
sudo chmod go+rw .
cd /

# Auto mount EFS storage on reboot
sudo echo "${mount_target}:/ ${mount_dir} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,fsc,_netdev 0 0" >> /etc/fstab

# Link directory to EFS mount directory
sudo ln -snf ${mount_dir} /var/nationalarchives.gov.uk

# Copy configuration files and scripts
sudo aws s3 cp s3://${deployment_s3_bucket}/${service}/${nginx_folder_s3_key}/ /etc/nginx/ --recursive --exclude "*" --include "*.conf"
sudo aws s3 cp s3://${deployment_s3_bucket}/${service}/${nginx_folder_s3_key}/nginx /etc/logrotate.d/nginx
sudo aws s3 cp s3://${deployment_s3_bucket}/${service}/${nginx_folder_s3_key}/update_nginx_confs.sh ~/update_nginx_confs.sh

# Restart nginx to reload new config file
sudo systemctl restart nginx

sudo mv ~/update_nginx_confs.sh /usr/local/sbin/update_nginx_confs.sh
sudo chmod u+x /usr/local/sbin/update_nginx_confs.sh

# Install CodeDeploy Agent
sudo yum install ruby -y
sudo yum install wget -y
CODEDEPLOY_BIN="/opt/codedeploy-agent/bin/codedeploy-agent"
$CODEDEPLOY_BIN stop
sudo yum erase codedeploy-agent -y
sudo wget https://aws-codedeploy-eu-west-2.s3.eu-west-2.amazonaws.com/latest/install
sudo chmod +x ./install
sudo ./install auto
