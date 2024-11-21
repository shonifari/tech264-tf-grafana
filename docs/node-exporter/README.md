# Node Exporter: An Overview

- [Node Exporter: An Overview](#node-exporter-an-overview)
  - [**Why Use Node Exporter?**](#why-use-node-exporter)
  - [**How Node Exporter Works**](#how-node-exporter-works)
  - [**Setting Up Node Exporter**](#setting-up-node-exporter)
    - [**Step-by-Step Installation**](#step-by-step-installation)
      - [**1. Download Node Exporter**](#1-download-node-exporter)
      - [**2. Extract the Binary**](#2-extract-the-binary)
      - [**3. Move the Binary**](#3-move-the-binary)
      - [**4. Create a Systemd Service**](#4-create-a-systemd-service)
      - [**5. Create a System User**](#5-create-a-system-user)
      - [**6. Start the Service**](#6-start-the-service)
      - [**7. Verify Node Exporter**](#7-verify-node-exporter)
  - [**Prometheus Configuration for Node Exporter**](#prometheus-configuration-for-node-exporter)
  - [**Example Metrics Exposed by Node Exporter**](#example-metrics-exposed-by-node-exporter)
  - [**Advanced Configuration**](#advanced-configuration)
    - [**1. Command-Line Flags**](#1-command-line-flags)
    - [**2. Running Node Exporter as a Docker Container**](#2-running-node-exporter-as-a-docker-container)
  - [**Conclusion**](#conclusion)

Node Exporter is a lightweight agent developed by Prometheus that collects hardware and OS metrics from Linux systems. It is an essential tool for monitoring the performance and health of your systems, as it provides a wide range of metrics such as CPU usage, memory usage, disk I/O, and network statistics.

---

## **Why Use Node Exporter?**

1. **System Metrics Collection**: Collect detailed metrics about the system's performance and health.
2. **Integration with Prometheus**: Node Exporter integrates seamlessly with Prometheus, making it easy to scrape and store metrics.
3. **Wide Range of Metrics**: Includes metrics like CPU load, memory utilization, disk space, and network activity.
4. **Lightweight**: Minimal resource usage on the monitored system.

---

## **How Node Exporter Works**

1. Node Exporter runs as a daemon on the target system.
2. It exposes system metrics via an HTTP endpoint (default: `http://<host>:9100/metrics`).
3. Prometheus scrapes these metrics at regular intervals using its configuration.
4. Metrics can then be visualized using tools like Grafana.

---

## **Setting Up Node Exporter**

### **Step-by-Step Installation**

#### **1. Download Node Exporter**

- Visit the [official Node Exporter GitHub releases page](https://github.com/prometheus/node_exporter/releases) to find the latest version.
- Download the binary:

  ```bash
  VERSION="1.6.1"  # Replace with the latest version
  wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-amd64.tar.gz
  ```

#### **2. Extract the Binary**

- Extract the downloaded file:

  ```bash
  tar -xvf node_exporter-${VERSION}.linux-amd64.tar.gz
  cd node_exporter-${VERSION}.linux-amd64
  ```

#### **3. Move the Binary**

- Move the `node_exporter` binary to `/usr/local/bin`:

  ```bash
  sudo mv node_exporter /usr/local/bin/
  ```

#### **4. Create a Systemd Service**

- Create a new service file for Node Exporter:

  ```bash
  sudo nano /etc/systemd/system/node_exporter.service
  ```

- Add the following content to the file:

  ```ini
  [Unit]
  Description=Node Exporter
  After=network.target

  [Service]
  User=node_exporter
  Group=node_exporter
  Type=simple
  ExecStart=/usr/local/bin/node_exporter

  [Install]
  WantedBy=multi-user.target
  ```

#### **5. Create a System User**

- Add a user for Node Exporter:

  ```bash
  sudo useradd --no-create-home --shell /bin/false node_exporter
  ```

#### **6. Start the Service**

- Reload systemd, enable, and start the service:

  ```bash
  sudo systemctl daemon-reload
  sudo systemctl enable node_exporter
  sudo systemctl start node_exporter
  ```

#### **7. Verify Node Exporter**

- Check if Node Exporter is running:

  ```bash
  sudo systemctl status node_exporter
  ```

- Confirm metrics are exposed:
  - Visit `http://<your-server-ip>:9100/metrics` in your browser.

---

## **Prometheus Configuration for Node Exporter**

Add the following job to your Prometheus configuration file (`prometheus.yml`) to scrape metrics from Node Exporter:

```yaml
scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']  # Replace 'localhost' with your Node Exporter host
```

Reload Prometheus to apply the changes:

```bash
sudo systemctl reload prometheus
```

---

## **Example Metrics Exposed by Node Exporter**

- **CPU Usage**: `node_cpu_seconds_total`
- **Memory Usage**: `node_memory_MemAvailable_bytes`, `node_memory_MemTotal_bytes`
- **Disk Space**: `node_filesystem_size_bytes`, `node_filesystem_free_bytes`
- **Network Traffic**: `node_network_receive_bytes_total`, `node_network_transmit_bytes_total`

---

## **Advanced Configuration**

### **1. Command-Line Flags**

Node Exporter supports command-line flags to enable or disable specific collectors. For example:

```bash
node_exporter --collector.cpu --collector.filesystem
```

### **2. Running Node Exporter as a Docker Container**

- Pull the official image:

  ```bash
  docker run -d --name=node_exporter -p 9100:9100 prom/node-exporter
  ```

---

## **Conclusion**

Node Exporter is a critical tool for system monitoring, providing extensive metrics about your hardware and operating system. When paired with Prometheus and Grafana, it forms the backbone of an effective monitoring stack, ensuring your infrastructure remains healthy and performant.
