#!/bin/bash

# PROMETHEUS


# Variables
# Extract the latest Prometheus version without the initial 'v'
PROMETHEUS_VERSION=$(curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/^v//')
INSTALL_DIR="/usr/local/bin"
DATA_DIR="/var/lib/prometheus"
CONFIG_DIR="/etc/prometheus"
USER="prometheus"
SERVICE_FILE="/etc/systemd/system/prometheus.service"

echo "Installing Prometheus version: $PROMETHEUS_VERSION"

# Create prometheus user and directories
echo "Creating Prometheus user and directories..."
sudo useradd --no-create-home --shell /bin/false $USER || true
sudo mkdir -p $DATA_DIR $CONFIG_DIR
sudo chown $USER:$USER $DATA_DIR $CONFIG_DIR


# Download and extract Prometheus
echo "Downloading Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz -O /tmp/prometheus.tar.gz
if [ $? -ne 0 ]; then
  echo "Failed to download Prometheus. Please check the version or network connectivity."
  exit 1
fi

tar -xzf /tmp/prometheus.tar.gz -C /tmp
if [ $? -ne 0 ]; then
  echo "Failed to extract Prometheus. Please check the downloaded archive."
  exit 1
fi

# Correct folder name
EXTRACTED_FOLDER="/tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64"
if [ ! -d "$EXTRACTED_FOLDER" ]; then
  echo "Extracted folder $EXTRACTED_FOLDER not found. Exiting."
  exit 1
fi

# Move Prometheus binaries to install directory
echo "Installing Prometheus binaries..."
sudo mv $EXTRACTED_FOLDER/prometheus $INSTALL_DIR/ || { echo "Failed to move Prometheus binary."; exit 1; }
sudo mv $EXTRACTED_FOLDER/promtool $INSTALL_DIR/ || { echo "Failed to move Promtool binary."; exit 1; }
sudo chown $USER:$USER $INSTALL_DIR/prometheus $INSTALL_DIR/promtool

# Check and move consoles and console_libraries if they exist
echo "Configuring Prometheus..."
if [ -d "$EXTRACTED_FOLDER/consoles" ]; then
  sudo mv $EXTRACTED_FOLDER/consoles $CONFIG_DIR/ || { echo "Failed to move consoles directory."; exit 1; }
  sudo chown -R $USER:$USER $CONFIG_DIR/consoles
fi

if [ -d "$EXTRACTED_FOLDER/console_libraries" ]; then
  sudo mv $EXTRACTED_FOLDER/console_libraries $CONFIG_DIR/ || { echo "Failed to move console libraries directory."; exit 1; }
  sudo chown -R $USER:$USER $CONFIG_DIR/console_libraries
fi

# Create Prometheus configuration file
echo "Creating Prometheus configuration file..."
cat <<EOF | sudo tee $CONFIG_DIR/prometheus.yml > /dev/null
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
EOF
sudo chown $USER:$USER $CONFIG_DIR/prometheus.yml

# Create systemd service file
echo "Creating Prometheus service..."
cat <<EOF | sudo tee $SERVICE_FILE
[Unit]
Description=Prometheus Monitoring System
Wants=network-online.target
After=network-online.target

[Service]
User=$USER
Group=$USER
Type=simple
ExecStart=$INSTALL_DIR/prometheus \\
  --config.file=$CONFIG_DIR/prometheus.yml \\
  --storage.tsdb.path=$DATA_DIR \\
  --web.console.templates=$CONFIG_DIR/consoles \\
  --web.console.libraries=$CONFIG_DIR/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Prometheus
echo "Starting Prometheus service..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Clean up
echo "Cleaning up..."
rm -rf /tmp/prometheus.tar.gz $EXTRACTED_FOLDER

echo "Prometheus installation and configuration completed successfully!"


