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

sudo bash -c '(
    crontab -l 2>/dev/null
    grep -Fq "/usr/local/bin/run_daily_task.sh" /var/spool/cron/root || echo "0 11 * * * /usr/local/bin/run_daily_task.sh >> /var/log/daily_task.log 2>&1"
    grep -Fq "/usr/local/bin/run_weekly_task.sh" /var/spool/cron/root || echo "0 8 * * 1 /usr/local/bin/run_weekly_task.sh >> /var/log/weekly_task.log 2>&1"
) | crontab -'


# included parameter store for automation in startup.sh
echo "$(date '+%Y-%m-%d %T') - call startup script" | sudo tee -a /var/log/start-up.log > /dev/null
/usr/local/bin/startup.sh
--//--
