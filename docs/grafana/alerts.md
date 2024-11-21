# Grafana Alerts: An Overview

- [Grafana Alerts: An Overview](#grafana-alerts-an-overview)
  - [**What Are Grafana Alerts?**](#what-are-grafana-alerts)
  - [**Key Features of Grafana Alerts**](#key-features-of-grafana-alerts)
  - [**Types of Alerts**](#types-of-alerts)
  - [**Steps to Create an Alert**](#steps-to-create-an-alert)
    - [**Creating an Alert (Unified Alerting)**](#creating-an-alert-unified-alerting)
    - [**Example: Create an Alert for CPU Usage**](#example-create-an-alert-for-cpu-usage)
      - [Alert Rule](#alert-rule)
      - [Steps](#steps)
  - [**Where Are Alert Configurations Stored?**](#where-are-alert-configurations-stored)
  - [**Provisioning Alerts**](#provisioning-alerts)
    - [**Steps to Provision Alerts**](#steps-to-provision-alerts)
  - [**Provisioning a Dashboard with Alerts**](#provisioning-a-dashboard-with-alerts)
  - [**Conclusion**](#conclusion)

Grafana alerts enable you to monitor your metrics and notify you when they reach specified thresholds. By combining visualization with real-time alerting, Grafana ensures you can respond promptly to critical issues.

---

## **What Are Grafana Alerts?**

Grafana alerts are rules that evaluate time-series data to detect specific conditions. When these conditions are met, notifications are sent through integrated communication channels such as email, Slack, PagerDuty, or others.

---

## **Key Features of Grafana Alerts**

1. **Flexible Rules**: Set thresholds for metrics based on your requirements.
2. **Multiple Notification Channels**: Configure alerts to notify you via email, messaging apps, or custom webhooks.
3. **Built-in Alert Manager**: Manage and group alerts efficiently.
4. **Multi-Dimensional Alerts**: Alerts can cover multiple conditions or metrics.

---

## **Types of Alerts**

1. **Legacy Alerts**:
   - Configured per dashboard panel.
   - Limited to individual visualizations.
2. **Unified Alerting (introduced in Grafana 8)**:
   - Centralized alerting for multiple data sources.
   - Grouping and routing alerts using Grafana's built-in Alertmanager.

---

## **Steps to Create an Alert**

### **Creating an Alert (Unified Alerting)**

1. **Access the Alerts Page**:
   - Navigate to **Alerting** > **Contact Points** in the Grafana interface.

2. **Set Up a Notification Channel**:
   - Go to **Contact Points**.
   - Click **New Contact Point** and configure the channel (e.g., Slack, Email).
   - Example:
     - Name: `Email Notification`
     - Type: `Email`
     - Recipient: `admin@example.com`

3. **Define an Alert Rule**:
   - Navigate to **Alert Rules**.
   - Click **New Alert Rule**.
   - Specify:
     - **Data Source**: Choose the source for metric evaluation (e.g., Prometheus).
     - **Query**: Write a query to fetch the desired metric.
     - **Condition**: Define thresholds (e.g., "WHEN value > 90").

4. **Link the Notification Channel**:
   - Under **Contact Points**, attach the notification channel to your alert.

5. **Save the Alert Rule**:
   - Name and save the rule.

---

### **Example: Create an Alert for CPU Usage**

#### Alert Rule

- **Metric**: `rate(node_cpu_seconds_total[5m])`
- **Condition**: Trigger when CPU usage exceeds 90% for more than 5 minutes.
- **Contact Point**: Email Notification.

#### Steps

1. Write the query in the alert rule's **Query** section:

   ```promql
   rate(node_cpu_seconds_total[5m]) * 100
   ```

2. Define the condition:
   - WHEN the **last value of Query (A)** is **above 90**.
3. Attach the **Email Notification** contact point.

---

## **Where Are Alert Configurations Stored?**

1. **Grafana Database**:
   - Alerts created via the web UI are stored in Grafana's database (`/var/lib/grafana/grafana.db` by default).

2. **Provisioning Files**:
   - Alert rules and notification channels can also be defined in YAML provisioning files for automation.

---

## **Provisioning Alerts**

Provisioning allows you to define alerts as code for consistent deployment across environments.

### **Steps to Provision Alerts**

1. **Create a Provisioning File**:
   - Example: `/etc/grafana/provisioning/alerting/alerts.yaml`

   ```yaml
   apiVersion: 1

   templates:
     - name: "CPU High Usage Alert"
       type: "prometheus"
       interval: "1m"
       rules:
         - alert: "HighCPUUsage"
           expr: "rate(node_cpu_seconds_total[5m]) * 100 > 90"
           for: "5m"
           labels:
             severity: "critical"
           annotations:
             summary: "High CPU usage detected"
             description: "CPU usage has exceeded 90% for over 5 minutes."
   ```

2. **Provision Notification Channels**:
   - Example: `/etc/grafana/provisioning/alerting/contact-points.yaml`

   ```yaml
   apiVersion: 1

   contactPoints:
     - name: "Email Notification"
       email:
         to: "admin@example.com"
   ```

3. **Restart Grafana**:
   - Apply the provisioning configuration:

     ```bash
     sudo systemctl restart grafana-server
     ```

---

## **Provisioning a Dashboard with Alerts**

1. Export or create a dashboard JSON with alert definitions.

   Example (`dashboard-with-alert.json`):

   ```json
   {
     "dashboard": {
       "title": "CPU Monitoring Dashboard",
       "panels": [
         {
           "type": "graph",
           "title": "CPU Usage",
           "alert": {
             "conditions": [
               {
                 "evaluator": { "params": [90], "type": "gt" },
                 "operator": { "type": "and" },
                 "query": { "params": ["A", "5m", "now"] },
                 "reducer": { "type": "avg" }
               }
             ],
             "name": "High CPU Alert",
             "executionErrorState": "alerting",
             "frequency": "1m"
           }
         }
       ]
     }
   }
   ```

2. Place the file in the provisioning directory:

   ```bash
   /etc/grafana/provisioning/dashboards/
   ```

3. Restart Grafana to load the dashboard and alerts:

   ```bash
   sudo systemctl restart grafana-server
   ```

---

## **Conclusion**

Grafana alerts are a powerful tool for monitoring metrics and triggering notifications when thresholds are exceeded. Whether configured through the web UI or provisioned using YAML files, they provide a flexible way to automate observability workflows. By integrating with contact points and dashboards, Grafana ensures seamless monitoring and alerting.
