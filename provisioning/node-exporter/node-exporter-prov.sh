#!/bin/bash

# Download the latest release of node_exporter for Linux
echo "Downloading the latest release of node_exporter..."
curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -

# Extract the downloaded tar.gz file
echo "Extracting node_exporter tar.gz file..."
tar -xvf node_exporter*.tar.gz

# Change directory to the extracted folder
echo "Changing directory to node_exporter..."
cd node_exporter*/

# Copy the node_exporter binary to /usr/local/bin
echo "Copying node_exporter binary to /usr/local/bin..."
sudo cp node_exporter /usr/local/bin

# Return to the home directory
echo "Returning to the home directory..."
cd

# Create a systemd service file for node_exporter
echo "Creating systemd service file for node_exporter..."
sudo tee /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

# Reload systemd to recognize the new service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Start the node_exporter service
echo "Starting node_exporter service..."
sudo systemctl start node_exporter

# Enable the node_exporter service to start on boot
echo "Enabling node_exporter service to start on boot..."
sudo systemctl enable node_exporter

echo "Node Exporter setup complete."
