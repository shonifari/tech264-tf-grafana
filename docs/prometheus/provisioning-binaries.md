# Provisioning Prometheus from binaries

- [Provisioning Prometheus from binaries](#provisioning-prometheus-from-binaries)
  - [Overview](#overview)
    - [**1: Define Variables**](#1-define-variables)
    - [**2: Display Installation Version**](#2-display-installation-version)
    - [**3: Create User and Directories**](#3-create-user-and-directories)
    - [**4: Download and Extract Prometheus**](#4-download-and-extract-prometheus)
    - [**5: Verify Extraction**](#5-verify-extraction)
    - [**6: Install Prometheus Binaries**](#6-install-prometheus-binaries)
    - [**7: Configure Additional Files**](#7-configure-additional-files)
    - [**8: Create Default Configuration**](#8-create-default-configuration)
    - [**9: Cleanup**](#9-cleanup)
    - [**Overall Workflow**](#overall-workflow)

## Overview

### **1: Define Variables**

```bash
# Extract the latest Prometheus version without the initial 'v'
PROMETHEUS_VERSION=$(curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/^v//')
INSTALL_DIR="/usr/local/bin"
DATA_DIR="/var/lib/prometheus"
CONFIG_DIR="/etc/prometheus"
USER="prometheus"
SERVICE_FILE="/etc/systemd/system/prometheus.service"
```

1. **`PROMETHEUS_VERSION`**: Fetches the latest Prometheus release version from GitHub's API and strips the leading `v`.
2. **`INSTALL_DIR`**: Directory where the Prometheus binary will be installed.
3. **`DATA_DIR`**: Directory for storing Prometheus data.
4. **`CONFIG_DIR`**: Directory for Prometheus configuration files.
5. **`USER`**: Name of the system user under which Prometheus will run.
6. **`SERVICE_FILE`**: Path for the systemd service file to manage Prometheus as a system service.

---

### **2: Display Installation Version**

```bash
echo "Installing Prometheus version: $PROMETHEUS_VERSION"
```

Displays the Prometheus version being installed, retrieved from the previous block.

---

### **3: Create User and Directories**

```bash
echo "Creating Prometheus user and directories..."
sudo useradd --no-create-home --shell /bin/false $USER || true
sudo mkdir -p $DATA_DIR $CONFIG_DIR
sudo chown $USER:$USER $DATA_DIR $CONFIG_DIR
```

1. **Create a User**: Adds a system user (`prometheus`) without a home directory or shell for security.
2. **Create Directories**: Sets up the directories for Prometheus data and configuration files.
3. **Change Ownership**: Assigns ownership of these directories to the `prometheus` user.

---

### **4: Download and Extract Prometheus**

```bash
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
```

1. **Download**: Downloads the Prometheus tarball for the latest version into `/tmp`.
2. **Error Check**: Verifies the download was successful.
3. **Extract**: Extracts the tarball into `/tmp` and checks for errors.

---

### **5: Verify Extraction**

```bash
EXTRACTED_FOLDER="/tmp/prometheus-${PROMETHEUS_VERSION}.linux-amd64"
if [ ! -d "$EXTRACTED_FOLDER" ]; then
  echo "Extracted folder $EXTRACTED_FOLDER not found. Exiting."
  exit 1
fi
```

Checks if the extracted directory exists. If not, the script exits with an error.

---

### **6: Install Prometheus Binaries**

```bash
echo "Installing Prometheus binaries..."
sudo mv $EXTRACTED_FOLDER/prometheus $INSTALL_DIR/ || { echo "Failed to move Prometheus binary."; exit 1; }
sudo mv $EXTRACTED_FOLDER/promtool $INSTALL_DIR/ || { echo "Failed to move Promtool binary."; exit 1; }
sudo chown $USER:$USER $INSTALL_DIR/prometheus $INSTALL_DIR/promtool
```

1. **Move Binaries**: Installs the `prometheus` and `promtool` binaries to the specified directory.
2. **Error Handling**: Ensures binaries are moved successfully; exits otherwise.
3. **Set Ownership**: Assigns ownership of the binaries to the `prometheus` user.

---

### **7: Configure Additional Files**

```bash
echo "Configuring Prometheus..."
if [ -d "$EXTRACTED_FOLDER/consoles" ]; then
  sudo mv $EXTRACTED_FOLDER/consoles $CONFIG_DIR/ || { echo "Failed to move consoles directory."; exit 1; }
  sudo chown -R $USER:$USER $CONFIG_DIR/consoles
fi

if [ -d "$EXTRACTED_FOLDER/console_libraries" ]; then
  sudo mv $EXTRACTED_FOLDER/console_libraries $CONFIG_DIR/ || { echo "Failed to move console libraries directory."; exit 1; }
  sudo chown -R $USER:$USER $CONFIG_DIR/console_libraries
fi
```

1. **Move Directories**: Moves `consoles` and `console_libraries` (optional components) to the configuration directory.
2. **Set Ownership**: Ensures these directories are owned by the `prometheus` user.

---

### **8: Create Default Configuration**

```bash
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
```

1. **Default Config**: Creates a minimal `prometheus.yml` configuration file with:
   - **Global Scrape Interval**: Scrapes metrics every 15 seconds.
   - **Scrape Jobs**:
     - Prometheus itself (`localhost:9090`).
     - Node Exporter (`localhost:9100`).
2. **Ownership**: Sets ownership of the configuration file.

---

### **9: Cleanup**

```bash
echo "Cleaning up..."
rm -rf /tmp/prometheus.tar.gz $EXTRACTED_FOLDER
```

Deletes the downloaded tarball and extracted files to free up temporary storage.

---

### **Overall Workflow**

1. Retrieve the latest Prometheus version.
2. Set up necessary directories and user.
3. Download and extract Prometheus binaries.
4. Install the binaries and configure files/directories.
5. Create a default configuration.
6. Clean up temporary files.

This script is a robust and error-checked method to install Prometheus manually on a Linux-based system.
