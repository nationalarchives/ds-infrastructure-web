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

sudo dnf -y install cronie 
sudo systemctl enable crond
sudo systemctl start crond

%{ if account == "live" }

echo "$(date '+%Y-%m-%d %T') - configure Merlin cron jobs" | sudo tee -a /var/log/start-up.log > /dev/null

(
    sudo crontab -l 2>/dev/null | grep -v '/usr/local/bin/merlin_process.sh'

    echo "0 3 * * * /usr/local/bin/merlin_process.sh this_week >> /var/log/merlin_process.log 2>&1"
    echo "0 2 1 * * /usr/local/bin/merlin_process.sh last_month >> /var/log/merlin_process.log 2>&1"

) | sudo crontab -

%{ endif }

# included parameter store for automation in startup.sh
echo "$(date '+%Y-%m-%d %T') - call startup script" | sudo tee -a /var/log/start-up.log > /dev/null
/usr/local/bin/startup.sh
--//--
