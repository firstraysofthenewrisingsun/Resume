#!/bin/bash
echo "Node-RED Install"

# Configure FW Rules
sudo ufw default deny incoming 
sudo ufw default allow outgoing
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 1880
sudo ufw enable

# Update the server
sudo apt-get update
sudo apt-get upgrade -y 
sudo apt-get autoremove 
sudo apt-get autoclean 

# Set the timezone to MST
sudo ln -fs /usr/share/zoneinfo/US/Mountain /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

# Install Havegd for boot time improvement
sudo apt-get install haveged -y

# Setup Node-RED
sudo apt install build-essential git curl
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
sudo systemctl enable nodered.service
sudo systemctl enable haveged.service

# Start Node-RED
node-red-start