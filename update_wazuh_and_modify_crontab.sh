#!/bin/bash
# This script uses to fix Wazuh Agent disconnected issue only.
# Written by SangNguyen.
#
#
# Use instruction:
## Download this file
## Grant execute permission: chmod +x update_wazuh_and_modify_crontab.sh
## ./update_wazuh_and_modify_crontab.sh
echo "Backing up the OSSEC configuration file..."
sudo cp /var/ossec/etc/ossec.conf /var/ossec/etc/ossec.conf.backup
if [ $? -ne 0 ]; then
    echo "Failed to backup OSSEC configuration file."
    exit 1
fi
echo "Modifying the OSSEC configuration file..."
sudo sed -i '/<protocol>tcp<\/protocol>/a \      <max_retries>100<\/max_retries>\n      <retry_interval>15<\/retry_interval>' /var/ossec/etc/ossec.conf
if [ $? -ne 0 ]; then
    echo "Failed to modify OSSEC configuration file."
    exit 1
fi
echo "Restarting the Wazuh agent..."
sudo systemctl restart wazuh-agent
if [ $? -ne 0 ]; then
    echo "Failed to restart the Wazuh agent."
    exit 1
fi
echo "Disabling the cron job..."
(crontab -l | sudo sed '/^\* 3 \* \* \* \/usr\/bin\/systemctl restart wazuh-agent$/s/^/#/') | sudo crontab -
if [ $? -ne 0 ]; then
    echo "Failed to disable the cron job."
    exit 1
fi
echo "All operations completed successfully."