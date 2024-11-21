# Script Breakdown: Grafana Installation and Setup

- [Script Breakdown: Grafana Installation and Setup](#script-breakdown-grafana-installation-and-setup)
  - [Overview](#overview)
    - [**2: Update and Upgrade System Packages**](#2-update-and-upgrade-system-packages)
    - [**3: Install Required Dependencies**](#3-install-required-dependencies)
    - [**4: Create Directory for Grafana GPG Key**](#4-create-directory-for-grafana-gpg-key)
    - [**5: Add Grafana GPG Key**](#5-add-grafana-gpg-key)
    - [**6: Add Grafana Repository**](#6-add-grafana-repository)
    - [**7: Update Package List**](#7-update-package-list)
    - [**8: Install Grafana**](#8-install-grafana)
    - [**9: Placeholder for Provisioning Data Sources**](#9-placeholder-for-provisioning-data-sources)
    - [**10: Reload systemd Daemon**](#10-reload-systemd-daemon)
    - [**11: Start Grafana Service**](#11-start-grafana-service)
    - [**12: Enable Grafana on Boot**](#12-enable-grafana-on-boot)
  - [Summary of Operations](#summary-of-operations)

---

## Overview

This script automates the process of installing and configuring Grafana on a Linux-based system. Each step is detailed below:

### **2: Update and Upgrade System Packages**

```bash
echo "Updating package list..."
sudo apt-get update -y

echo "Upgrading installed packages..."
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
```

- **Update Package List**: Fetches the latest list of available packages and versions.
- **Upgrade Packages**: Installs updates for all currently installed packages.
- The `DEBIAN_FRONTEND=noninteractive` ensures the upgrade runs without requiring user input.

---

### **3: Install Required Dependencies**

```bash
echo "Installing necessary packages for Grafana..."
sudo apt-get install -y apt-transport-https software-properties-common wget
```

- Installs the following dependencies:
  - `apt-transport-https`: Allows the package manager to use HTTPS for fetching files.
  - `software-properties-common`: Provides tools to manage software sources.
  - `wget`: A utility to download files from the web.

---

### **4: Create Directory for Grafana GPG Key**

```bash
echo "Creating directory for Grafana GPG key..."
sudo mkdir -p /etc/apt/keyrings/
```

- Creates a directory `/etc/apt/keyrings/` to store the GPG key securely.

---

### **5: Add Grafana GPG Key**

```bash
echo "Downloading and adding Grafana GPG key..."
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
```

- Downloads the Grafana GPG key to ensure the integrity and authenticity of Grafana packages.
- Converts the key into a binary format using `gpg --dearmor`.
- Saves the key to `/etc/apt/keyrings/grafana.gpg`.

---

### **6: Add Grafana Repository**

```bash
echo "Adding Grafana repository to sources list..."
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
```

- Adds the Grafana APT repository to the system's sources list for package management.
- Specifies that packages should be verified using the previously added GPG key.

---

### **7: Update Package List**

```bash
echo "Updating package list to include Grafana repository..."
sudo apt-get update -y
```

- Refreshes the package list to include packages from the newly added Grafana repository.

---

### **8: Install Grafana**

```bash
echo "Installing Grafana..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install grafana -y
```

- Installs the Grafana software package using `apt-get`.
- The `DEBIAN_FRONTEND=noninteractive` flag ensures the process does not prompt for user interaction.

---

### **9: Placeholder for Provisioning Data Sources**

```bash
# **PROVISION DATASOURCES HERE**
```

- Placeholder for additional steps to configure data sources for Grafana.

---

### **10: Reload systemd Daemon**

```bash
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload
```

- Reloads the `systemd` manager to recognize the new Grafana service.

---

### **11: Start Grafana Service**

```bash
echo "Starting Grafana server..."
sudo systemctl start grafana-server
```

- Starts the Grafana server process.

---

### **12: Enable Grafana on Boot**

```bash
echo "Enabling Grafana server to start on boot..."
sudo systemctl enable grafana-server.service
```

- Configures the Grafana server to automatically start when the system boots.

---

## Summary of Operations

1. Updates and upgrades system packages.
2. Installs required dependencies.
3. Adds Grafana's GPG key and repository for secure and verified installations.
4. Installs Grafana and starts its service.
5. Ensures Grafana will automatically start on boot.
6. Provides a placeholder to add data source provisioning steps.

This script simplifies the installation process, making it repeatable and efficient for new deployments.
