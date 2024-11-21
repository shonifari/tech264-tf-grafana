# Prometheus: Overview, Architecture, and Functionality  

- [Prometheus: Overview, Architecture, and Functionality](#prometheus-overview-architecture-and-functionality)
  - [What is Prometheus?](#what-is-prometheus)
    - [Key Features](#key-features)
  - [Why Use Prometheus?](#why-use-prometheus)
  - [Prometheus Architecture](#prometheus-architecture)
    - [1. **Prometheus Server**](#1-prometheus-server)
    - [2. **Data Collection (Exporters)**](#2-data-collection-exporters)
    - [3. **Service Discovery**](#3-service-discovery)
    - [4. **PromQL (Prometheus Query Language)**](#4-promql-prometheus-query-language)
    - [5. **Alertmanager**](#5-alertmanager)
    - [6. **Grafana Integration**](#6-grafana-integration)
  - [Prometheus Workflow](#prometheus-workflow)
    - [Step 1: Define Metrics](#step-1-define-metrics)
    - [Step 2: Scrape Metrics](#step-2-scrape-metrics)
    - [Step 3: Store Metrics](#step-3-store-metrics)
    - [Step 4: Query and Analyze](#step-4-query-and-analyze)
    - [Step 5: Trigger Alerts](#step-5-trigger-alerts)
  - [Key Components of Prometheus Metrics](#key-components-of-prometheus-metrics)
  - [Prometheus Use Cases](#prometheus-use-cases)
  - [Limitations of Prometheus](#limitations-of-prometheus)
  - [Setting Up Prometheus](#setting-up-prometheus)
    - [Step 1: Install Prometheus](#step-1-install-prometheus)
    - [Step 2: Configure Targets](#step-2-configure-targets)
    - [Step 3: Start Prometheus](#step-3-start-prometheus)
  - [Conclusion](#conclusion)

Prometheus is an open-source **monitoring and alerting toolkit** designed for recording real-time metrics in a time-series database. Originally developed by SoundCloud in 2012, it is now a part of the Cloud Native Computing Foundation (CNCF) and has become one of the most popular monitoring solutions for cloud-native applications.

---

## What is Prometheus?

Prometheus is a **time-series database** and monitoring system that specializes in collecting, storing, and querying metrics. It is widely used in cloud-native and containerized environments due to its simplicity, efficiency, and integration with tools like **Kubernetes** and **Grafana**.

### Key Features

- **Time-Series Data Storage**: Optimized for storing timestamped data with labels for contextual information.
- **Multi-Dimensional Data Model**: Organizes metrics using key-value pairs, allowing flexible querying and aggregation.
- **Pull-Based Architecture**: Actively scrapes metrics from targets, as opposed to relying on them to push data.
- **Powerful Query Language ([PromQL](promQL.md))**: A flexible and expressive query language designed for aggregating and analyzing metrics.
- **Built-In Alerting**: Generates alerts based on user-defined rules, integrating with notification systems like Slack, PagerDuty, and email.
- **Scalable and Decentralized**: Each Prometheus server operates independently, without relying on external dependencies.

---

## Why Use Prometheus?

Prometheus excels in scenarios where metrics collection and real-time monitoring are critical. Some common benefits include:

1. **Real-Time Metrics**  
   Prometheus collects metrics at frequent intervals, providing near-instantaneous updates.  

2. **Cloud-Native and Container Integration**  
   Designed with Kubernetes in mind, Prometheus can automatically discover and monitor services in dynamic environments.  

3. **Flexible Querying**  
   With [PromQL](promQL.md), users can perform advanced calculations, aggregations, and visualizations on collected data.  

4. **Open Source**  
   Prometheus is free, actively maintained, and supported by a large community.  

5. **Built-In Alerting**  
   Alerts are defined based on metric thresholds and are seamlessly integrated into the system.  

---

## Prometheus Architecture  

Prometheus's architecture is modular, consisting of several key components working together to collect, store, query, and visualize metrics.

### 1. **Prometheus Server**  

The central component responsible for:  

- **Scraping Metrics**: Fetching data from monitored targets via HTTP endpoints.  
- **Storing Metrics**: Storing time-series data in a local database optimized for high performance.  
- **Querying Data**: Allowing users to query stored metrics using [PromQL](promQL.md).  

### 2. **Data Collection (Exporters)**  

Prometheus uses **exporters** to collect metrics from various sources, such as:  

- **Node Exporter**: System-level metrics like CPU, memory, and disk usage.  
- **Application-Specific Exporters**: For popular software like MySQL, Redis, and Nginx.  
- **Custom Exporters**: Built by users to expose application-specific metrics.  

### 3. **Service Discovery**  

Prometheus dynamically discovers targets using service discovery mechanisms, such as:  

- **Kubernetes**: Automatically finds pods, services, and endpoints.  
- **Consul and etcd**: Discovers services in distributed systems.  
- **Static Configuration**: Predefined list of targets.  

### 4. **PromQL (Prometheus Query Language)**  

[PromQL](promQL.md) is used to query and manipulate the metrics collected by Prometheus. It supports:  

- Arithmetic and aggregation functions.  
- Filtering and grouping using metric labels.  
- Time-series transformations and rate calculations.  

Example Query:  

```promql
rate(http_requests_total[5m])
```

This calculates the per-second rate of HTTP requests over the last 5 minutes.  

### 5. **Alertmanager**  

Prometheus integrates with **Alertmanager** to handle alerts.  

- Alerts are defined in the Prometheus configuration and triggered when conditions are met.  
- Alertmanager routes alerts to channels like email, Slack, PagerDuty, or custom webhooks.  

### 6. **Grafana Integration**  

Although Prometheus has a basic built-in UI, Grafana is often used for advanced data visualization. Prometheus serves as a data source for Grafana dashboards.

---

## Prometheus Workflow  

### Step 1: Define Metrics  

Applications expose metrics using HTTP endpoints in a specific format (usually `/metrics`). Prometheus-compatible libraries or exporters are used to generate these metrics.

### Step 2: Scrape Metrics  

Prometheus server scrapes metrics from targets at defined intervals. Targets can be:  

- Exporters (e.g., Node Exporter).  
- Application endpoints (e.g., `/metrics`).  
- Pushgateway (for short-lived jobs).  

### Step 3: Store Metrics  

Metrics are stored in a time-series database with labels providing context. For example:  

```plaintext
http_requests_total{method="GET", handler="/api", status="200"}
```

### Step 4: Query and Analyze  

Users interact with Prometheus through [PromQL](promQL.md) queries to extract and analyze metrics. These queries can be used to create dashboards or set up alerts.

### Step 5: Trigger Alerts  

When metric thresholds are violated (e.g., high CPU usage or error rates), Prometheus generates alerts and sends them to Alertmanager for routing.

---

## Key Components of Prometheus Metrics  

Prometheus organizes metrics into **time-series**, each uniquely identified by:  

1. **Metric Name**  
   A human-readable name that represents the metric.  
   Example: `http_requests_total`  

2. **Labels**  
   Key-value pairs that add context to metrics.  
   Example:  

   ```plaintext
   http_requests_total{method="GET", status="200"}
   ```

3. **Timestamps**  
   Each data point is associated with a specific time.  

---

## Prometheus Use Cases  

1. **Infrastructure Monitoring**  
   - Monitor CPU, memory, and disk usage of servers.  
   - Use Node Exporter for system-level metrics.  

2. **Application Performance Monitoring (APM)**  
   - Measure application latency, request counts, and error rates.  
   - Track microservices communication in Kubernetes.  

3. **Alerting and Incident Management**  
   - Set alerts for SLA violations or resource exhaustion.  
   - Route critical alerts to on-call teams via Alertmanager.  

4. **IoT and Sensor Data**  
   - Collect metrics from IoT devices for analysis.  
   - Track environmental or usage data in real time.  

---

## Limitations of Prometheus  

While powerful, Prometheus has some limitations:  

- **Single Server Scaling**: Each Prometheus server operates independently, which can lead to scaling challenges.  
- **No Long-Term Storage**: Data retention is limited by local storage; external systems (e.g., Thanos or Cortex) are required for long-term storage.  
- **Pull-Based Only**: Metrics must be exposed via HTTP endpoints for scraping. Pushgateway is an option for temporary jobs but not for long-term metrics.  

---

## Setting Up Prometheus  

### Step 1: Install Prometheus  

Prometheus can be installed via [Docker](provisioning-docker.md), Kubernetes Helm charts, or [directly from binaries](provisioning-binaries.md).  

### Step 2: Configure Targets  

Edit the `prometheus.yml` configuration file to define scrape targets and intervals. Example:  

```yaml
scrape_configs:
  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]
```

### Step 3: Start Prometheus  

Run Prometheus and access its web UI at `http://localhost:9090`.  

---

## Conclusion  

Prometheus is a robust and flexible monitoring solution, ideal for real-time metrics collection in cloud-native environments. Its ability to integrate seamlessly with Kubernetes, coupled with powerful querying and alerting features, makes it a cornerstone of modern observability stacks. For extended capabilities, Prometheus is often paired with tools like Grafana and Alertmanager, ensuring a comprehensive monitoring and alerting ecosystem.  

For more details, visit the [official Prometheus documentation](https://prometheus.io/docs/).  
