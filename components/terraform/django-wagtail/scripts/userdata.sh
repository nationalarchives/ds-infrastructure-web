Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash

sudo touch /var/log/start-up.log

echo "$(date '+%Y-%m-%d %T') - system update" | sudo tee -a /var/log/start-up.log > /dev/null
sudo dnf -y update

#echo "$(date '+%Y-%m-%d %T') - install EFS utilities" | sudo tee -a /var/log/start-up.log > /dev/null
#sudo dnf install -y amazon-efs-utils

# mounting process for EFS
echo "$(date '+%Y-%m-%d %T') - check if media directory exist" | sudo tee -a /var/log/start-up.log > /dev/null
BASE_DIR="$${mount_dir}"
if [ ! -d "$BASE_DIR" ]; then
  echo "$(date '+%Y-%m-%d %T') - create media directory" | sudo tee -a /var/log/start-up.log > /dev/null
  sudo mkdir -p $BASE_DIR
else
  echo "$(date '+%Y-%m-%d %T') - media directory found" | sudo tee -a /var/log/start-up.log > /dev/null
fi

# Mount EFS storage
echo "$(date '+%Y-%m-%d %T') - check if EFS is mounted" | sudo tee -a /var/log/start-up.log > /dev/null
mounted=$(df -h --type=nfs4 | grep $BASE_DIR)
if [ -z "$${mounted}" ]; then
  echo "$(date '+%Y-%m-%d %T') - set up system for persistent mounting of EBS" | sudo tee -a /var/log/start-up.log > /dev/null
  sudo echo "${mount_target}:/ ${mount_dir} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,fsc,_netdev 0 0" >> /etc/fstab
  echo "$(date '+%Y-%m-%d %T') - mount of EBS" | sudo tee -a /var/log/start-up.log > /dev/null
  sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${mount_target}:/ ${mount_dir}
else
  echo "$(date '+%Y-%m-%d %T') - EBS found)" | sudo tee -a /var/log/start-up.log > /dev/null
fi

echo "$(date '+%Y-%m-%d %T') - call startup script" | sudo tee -a /var/log/start-up.log > /dev/null
/usr/local/bin/startup.sh

#docker inspect --format='{{range $key, $value := .NetworkSettings.Networks}}{{if eq $key "'"traefik_webgateway"'"}}{{$value.IPAddress}}{{end}}{{end}}' "blue-dw"
--//--
