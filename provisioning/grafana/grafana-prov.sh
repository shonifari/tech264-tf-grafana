#!/bin/bash

# Echo statement to indicate the start of the update and upgrade process
echo "[UPDATE & UPGRADE PACKAGES]"

# Update package list
echo "Updating package list..."
sudo apt-get update -y

# Upgrade all installed packages
echo "Upgrading installed packages..."
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Install necessary packages for Grafana
echo "Installing necessary packages for Grafana..."
sudo apt-get install -y apt-transport-https software-properties-common wget

# Create directory for Grafana GPG key
echo "Creating directory for Grafana GPG key..."
sudo mkdir -p /etc/apt/keyrings/

# Download and add Grafana GPG key
echo "Downloading and adding Grafana GPG key..."
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add Grafana repository to sources list
echo "Adding Grafana repository to sources list..."
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Update package list again to include Grafana repository
echo "Updating package list to include Grafana repository..."
sudo apt-get update -y

# Install Grafana
echo "Installing Grafana..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install grafana -y

# **PROVISION DATASOURCES HERE**

# Reload systemd daemon to recognize new service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Start Grafana server
echo "Starting Grafana server..."
sudo systemctl start grafana-server

# Enable Grafana server to start on boot
echo "Enabling Grafana server to start on boot..."
sudo systemctl enable grafana-server.service

# Echo statement to indicate the end of the script
echo "Grafana setup and provisioning complete."
