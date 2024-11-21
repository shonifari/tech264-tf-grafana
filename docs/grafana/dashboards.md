# Grafana Dashboards: An Overview

- [Grafana Dashboards: An Overview](#grafana-dashboards-an-overview)
  - [**What Are Grafana Dashboards?**](#what-are-grafana-dashboards)
  - [**Key Features of Grafana Dashboards**](#key-features-of-grafana-dashboards)
  - [**Setting Up a Dashboard**](#setting-up-a-dashboard)
    - [**Steps to Create a New Dashboard in Grafana**](#steps-to-create-a-new-dashboard-in-grafana)
  - [**Where Are Configurations Stored?**](#where-are-configurations-stored)
  - [**Provisioning Dashboards**](#provisioning-dashboards)
    - [**Steps to Provision a Dashboard**](#steps-to-provision-a-dashboard)
  - [**Example: Provision a Dashboard**](#example-provision-a-dashboard)
    - [Dashboard JSON File (`/etc/grafana/provisioning/dashboards/sample-dashboard.json`)](#dashboard-json-file-etcgrafanaprovisioningdashboardssample-dashboardjson)
    - [Provisioning Configuration (`/etc/grafana/provisioning/dashboards/dashboards.yaml`)](#provisioning-configuration-etcgrafanaprovisioningdashboardsdashboardsyaml)
    - [Restart Grafana](#restart-grafana)
  - [**Advantages of Provisioning Dashboards**](#advantages-of-provisioning-dashboards)
  - [**Conclusion**](#conclusion)

Grafana dashboards are customizable interfaces that allow you to visualize and monitor your data using various visualization panels such as graphs, tables, gauges, and more. Dashboards are a core feature of Grafana, designed for tracking metrics and observing system performance across different time-series data sources.

---

## **What Are Grafana Dashboards?**

- **Dashboards** are collections of panels organized on a grid.
- Each **panel** represents a specific visualization or query result.
- Dashboards can include real-time updates, interactive elements, and multiple data sources.
- Common use cases:
  - Monitoring system performance.
  - Visualizing application metrics.
  - Alerting on predefined thresholds.

---

## **Key Features of Grafana Dashboards**

1. **Panels**:
   - Building blocks of a dashboard.
   - Types include graphs, tables, heatmaps, and stat panels.

2. **Variables**:
   - Allow dynamic selection of data (e.g., filtering by server or environment).

3. **Templating**:
   - Use variables to create reusable dashboards.

4. **Time Range Controls**:
   - Adjust the time period for which data is displayed.

5. **Multi-Source Data**:
   - Combine data from multiple sources (e.g., Prometheus, Elasticsearch).

6. **Alerting**:
   - Trigger alerts based on data thresholds.

---

## **Setting Up a Dashboard**

### **Steps to Create a New Dashboard in Grafana**

1. **Access the Grafana Interface**:
   - Navigate to `http://<your-grafana-server>:3000` and log in.

2. **Create a Dashboard**:
   - Go to **Dashboards** > **+ New Dashboard**.

3. **Add Panels**:
   - Click **Add a new panel**.
   - Select a visualization type (e.g., graph, table).
   - Write a query to fetch data from a data source.
   - Configure the panel's settings (e.g., title, thresholds).

4. **Save the Dashboard**:
   - Click **Save dashboard**, provide a name, and optionally add tags.

---

## **Where Are Configurations Stored?**

1. **In the Grafana Database**:
   - By default, dashboards created via the web interface are stored in Grafana's SQLite database (`/var/lib/grafana/grafana.db`).

2. **Provisioning Files**:
   - Dashboards can be defined as JSON configuration files.
   - These files are stored in `/var/lib/grafana/provisioning/dashboards/` or other custom paths defined in the Grafana configuration.

---

## **Provisioning Dashboards**

Provisioning allows you to define and manage dashboards as code. This ensures repeatability and ease of deployment.

### **Steps to Provision a Dashboard**

1. **Prepare the JSON Configuration**:
   - Export an existing dashboard:
     - Go to the dashboard, click the gear icon, and choose **JSON Model**.
     - Save the JSON file locally.

2. **Create a Provisioning Configuration File**:
   - Example: `/etc/grafana/provisioning/dashboards/dashboards.yaml`

   ```yaml
   apiVersion: 1
   providers:
     - name: "default"
       folder: "Provisioned Dashboards"
       type: "file"
       disableDeletion: true
       options:
         path: "/etc/grafana/provisioning/dashboards"
   ```

3. **Save the JSON Dashboard File**:
   - Place your dashboard JSON file in the directory specified in the `path` field of the YAML file (`/etc/grafana/provisioning/dashboards`).

4. **Restart Grafana**:
   - Reload Grafana to apply the configuration:

     ```bash
     sudo systemctl restart grafana-server
     ```

---

## **Example: Provision a Dashboard**

### Dashboard JSON File (`/etc/grafana/provisioning/dashboards/sample-dashboard.json`)

```json
{
  "dashboard": {
    "id": null,
    "title": "Sample Dashboard",
    "panels": [
      {
        "type": "graph",
        "title": "CPU Usage",
        "targets": [
          {
            "expr": "rate(cpu_usage[5m])",
            "legendFormat": "{{instance}}"
          }
        ]
      }
    ],
    "time": {
      "from": "now-1h",
      "to": "now"
    }
  },
  "overwrite": true
}
```

### Provisioning Configuration (`/etc/grafana/provisioning/dashboards/dashboards.yaml`)

```yaml
apiVersion: 1
providers:
  - name: "default"
    folder: "Provisioned Dashboards"
    type: "file"
    disableDeletion: false
    editable: true
    options:
      path: "/etc/grafana/provisioning/dashboards"
```

### Restart Grafana

```bash
sudo systemctl restart grafana-server
```

After restarting, the dashboard will be available under the **Provisioned Dashboards** folder in Grafana.

---

## **Advantages of Provisioning Dashboards**

- **Automation**: Simplifies deployment and version control.
- **Consistency**: Ensures dashboards are identical across environments.
- **Scalability**: Easy to manage dashboards for large systems.

---

## **Conclusion**

Grafana dashboards provide a powerful and flexible way to visualize your data. With provisioning, you can define dashboards as code, enabling seamless deployment and management. This approach ensures that your monitoring setup remains consistent, repeatable, and easy to maintain.
