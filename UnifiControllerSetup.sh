#!/bin/bash
echo "Unifi Controller Bash Install"

# Configure FW Rules
sudo ufw default deny incoming 
sudo ufw default allow outgoing
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 3478/udp
sudo ufw allow 8080
sudo ufw allow 8443
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

# Install the necessary packages
sudo apt-get install -y wget apt-transport-https gnupg

# Download the GPG key:
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -

# Add the repository
echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb buster main" | sudo tee /etc/apt/sources.list.d/adoptopenjdk.list

# Install Java 8
sudo apt-get update; 
sudo apt-get install adoptopenjdk-8-hotspot

# UNIFI INSTALL
# Add the repository
echo 'deb http://www.ui.com/downloads/unifi/debian stable ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list

# Authenticate the repository
sudo wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ubnt.com/unifi/unifi-repo.gpg

# Add MongoDB 3.6 repository (dependency issue with Unifi)
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list

sudo wget -qO - https://www.mongodb.org/static/pgp/server-3.6.asc | sudo apt-key add -

# Install Unifi Network App
sudo apt-get update;
sudo apt-get install unifi -y

# Set automatic start of critical services at boot
sudo systemctl enable unifi.service
sudo systemctl enable mongod.service
sudo systemctl enable haveged.service

# Install Certbot
sudo apt install certbot python3-certbot-apache -y