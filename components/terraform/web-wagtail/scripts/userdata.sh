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

echo "Creating mount directory..."

# Mount EFS storage
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${mount_target}:/ ${web_wagtail_efs_mount_dir}

# Auto mount EFS storage on reboot
sudo echo "${mount_target}:/ ${web_wagtail_efs_mount_dir} nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,fsc,_netdev 0 0" >> /etc/fstab

sudo touch /var/log/start-up.log

echo "$(date '+%Y-%m-%d %T') - system update" | sudo tee -a /var/log/start-up.log > /dev/null

sudo yum install -y cronie
sudo systemctl enable crond
sudo systemctl start crond
chmod +x /usr/local/bin/refresh_aws_keys.sh
sudo touch /var/log/refresh_aws_keys.log
sudo chmod 664 /var/log/refresh_aws_keys.log
sudo chown $(whoami): /var/log/refresh_aws_keys.log

sudo /usr/local/bin/refresh_aws_keys.sh


# Add cron job
(
    sudo crontab -l 2>/dev/null | grep -v '/usr/local/bin/refresh_aws_keys.sh' | grep -v '/usr/local/bin/upload-media-to-s3.sh'
    echo "*/30 * * * * /usr/local/bin/refresh_aws_keys.sh >> /var/log/refresh_aws_keys.log 2>&1"
    echo "0 15 * * 2 /usr/local/bin/upload-media-to-s3.sh >> /var/log/media_backup.log 2>&1"
) | sudo crontab -

sudo dnf -y update
# included parameter store for automation in startup.sh
echo "$(date '+%Y-%m-%d %T') - call startup script" | sudo tee -a /var/log/start-up.log > /dev/null
/usr/local/bin/startup.sh
--//--
