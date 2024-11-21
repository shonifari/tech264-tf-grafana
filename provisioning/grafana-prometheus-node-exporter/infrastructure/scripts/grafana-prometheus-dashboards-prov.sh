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

# Provision Grafana with Prometheus data source
echo "Provisioning Grafana with Prometheus data source..."
cat <<EOF > /etc/grafana/provisioning/datasources/prometheus.yml
${PROMETHEUS_DATASOURCE_YML}
EOF

# DASHBOARD

# Configure Prometheus dashboard
echo "Provisioning Grafana dashboard..."
cat <<EOF > /etc/grafana/provisioning/dashboards/dashboard.yml
${PROMETHEUS_DASHBOARD_YML}
EOF

echo "Creating the dashboards folder" 
mkdir /var/lib/grafana/dashboards

echo "Creating dashboard..."
curl "https://raw.githubusercontent.com/shonifari/grafana/refs/heads/main/dashboards/key-metrics-dbd.json" -o /var/lib/grafana/dashboards/dashboard.json





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
wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz -O /tmp/prometheus.tar.gz
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
EXTRACTED_FOLDER="/tmp/prometheus-$PROMETHEUS_VERSION.linux-amd64"
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
${PROMETHEUS_CONFIG_YML}
EOF
sudo chown $USER:$USER $CONFIG_DIR/prometheus.yml

# Create systemd service file
echo "Creating Prometheus service..."
cat <<EOF | sudo tee $SERVICE_FILE
${PROMETHEUS_SERVICE_FILE}
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



# NODE EXPORTER

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
${NODE_EXPORTER_SERVICE_FILE}
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


