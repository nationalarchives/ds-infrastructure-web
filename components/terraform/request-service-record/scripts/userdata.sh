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

sudo yum install -y cronie
sudo systemctl enable crond
sudo systemctl start crond
chmod +x /usr/local/bin/refresh_aws_keys.sh
sudo touch /var/log/refresh_aws_keys.log
sudo chmod 664 /var/log/refresh_aws_keys.log
sudo chown $(whoami): /var/log/refresh_aws_keys.log

sudo /usr/local/bin/refresh_aws_keys.sh

(
    sudo crontab -l 2>/dev/null | grep -v '/usr/local/bin/refresh_aws_keys.sh'
    echo "*/30 * * * * /usr/local/bin/refresh_aws_keys.sh >> /var/log/refresh_aws_keys.log 2>&1"
) | sudo crontab -
sudo dnf -y update
# included parameter store for automation in startup.sh
echo "$(date '+%Y-%m-%d %T') - call startup script" | sudo tee -a /var/log/start-up.log > /dev/null
/usr/local/bin/startup.sh
--//--
