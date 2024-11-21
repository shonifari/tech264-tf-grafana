# Introduction to PromQL (Prometheus Query Language)

PromQL, or Prometheus Query Language, is a powerful and flexible language designed to query, manipulate, and aggregate metrics stored in Prometheus. Its main purpose is to enable users to extract and analyze time-series data for monitoring, alerting, and visualization.

---

## Core Concepts in PromQL

### 1. **Metric Names**

- Metric names are human-readable identifiers for time-series data.
- Examples:
  - `http_requests_total`: Total number of HTTP requests.
  - `cpu_usage`: CPU utilization.

### 2. **Labels**

- Labels are key-value pairs that provide additional context to metrics.
- Example:

  ```plaintext
  http_requests_total{method="GET", status="200"}
  ```

  Here:
  - `method="GET"` indicates the HTTP method.
  - `status="200"` indicates the HTTP response status code.

### 3. **Time-Series**

- Prometheus stores metrics as **time-series data**, where each data point consists of:
  - **Metric Name**: Identifier for the time-series.
  - **Labels**: Provide dimensionality.
  - **Timestamps**: Indicate when the metric was recorded.
  - **Values**: Represent the metric's value at a given time.

---

## PromQL Query Types

PromQL supports three primary types of queries:

### 1. **Instant Queries**

- Return the current value of a metric at a single point in time.
- Example:

  ```promql
  cpu_usage
  ```

  Retrieves the current CPU usage for all instances.

### 2. **Range Queries**

- Return a range of values for a metric over a specific time window.
- Example:

  ```promql
  cpu_usage[5m]
  ```

  Retrieves CPU usage over the last 5 minutes.

### 3. **Aggregate Queries**

- Perform operations like sum, average, or max over multiple time-series.
- Example:

  ```promql
  sum(cpu_usage)
  ```

  Sums the CPU usage across all instances.

---

## Operators in PromQL

### 1. **Arithmetic Operators**

Used to perform basic calculations on metric values.

| Operator | Description |
|----------|-------------|
| `+`      | Addition    |
| `-`      | Subtraction |
| `*`      | Multiplication |
| `/`      | Division    |

#### Example

```promql
http_requests_total / 60
```

Converts the total HTTP requests into requests per second.

### 2. **Comparison Operators**

Used to filter metrics based on conditions.

| Operator | Description |
|----------|-------------|
| `==`     | Equals      |
| `!=`     | Not equal   |
| `>`      | Greater than |
| `<`      | Less than    |

#### Example

```promql
cpu_usage > 0.8
```

Filters CPU usage metrics greater than 80%.

### 3. **Logical/Set Operators**

Used to combine or compare multiple time-series.

| Operator | Description         |
|----------|---------------------|
| `and`    | Intersection        |
| `or`     | Union               |
| `unless` | Exclude time-series |

#### Example

```promql
up{job="web"} and cpu_usage
```

Returns CPU usage only for web jobs that are up.

---

## Functions in PromQL

PromQL provides various built-in functions to manipulate time-series data. Below are some common ones:

### 1. **Rate and Increase**

- `rate()`: Calculates the per-second average rate of increase over a time range.
- `increase()`: Calculates the total increase over a time range.

#### Example

```promql
rate(http_requests_total[5m])
```

Calculates the average request rate per second over the last 5 minutes.

### 2. **Aggregation**

- `sum()`: Sums up metrics across labels.
- `avg()`: Computes the average.
- `max()`: Finds the maximum value.

#### Example

```promql
sum(rate(http_requests_total[1m]))
```

Sums the request rate across all instances.

### 3. **Time Manipulation**

- `time()`: Returns the current Unix timestamp.

#### Example

```promql
time() - 3600
```

Returns the Unix timestamp for 1 hour ago.

### 4. **Histogram Functions**

- `histogram_quantile()`: Calculates quantiles (e.g., 90th percentile) for histogram metrics.

#### Example

```promql
histogram_quantile(0.9, rate(http_request_duration_seconds_bucket[5m]))
```

Returns the 90th percentile for HTTP request durations.

---

## Label Filtering

You can filter metrics based on specific labels using `{key="value"}` syntax.

### Examples

#### Match Specific Labels

```promql
http_requests_total{method="GET"}
```

Filters metrics where the method is `GET`.

#### Exclude Specific Labels

```promql
http_requests_total{method!="GET"}
```

Filters out metrics where the method is `GET`.

#### Match Multiple Labels

```promql
http_requests_total{method="GET", status="200"}
```

Filters metrics with method `GET` and status `200`.

---

## Common PromQL Queries

1. **Uptime Check**:

   ```promql
   up
   ```

   Displays the status (1 = up, 0 = down) of all monitored instances.

2. **CPU Usage per Instance**:

   ```promql
   rate(cpu_usage[1m])
   ```

   Calculates the CPU usage rate for each instance over the last minute.

3. **Total HTTP Requests**:

   ```promql
   sum(rate(http_requests_total[5m]))
   ```

   Sums the HTTP request rate across all instances.

4. **Disk Usage Above Threshold**:

   ```promql
   disk_usage > 0.9
   ```

   Finds instances where disk usage exceeds 90%.

5. **Memory Usage per Node**:

   ```promql
   sum(memory_usage) by (node)
   ```

   Aggregates memory usage by node.

---

## Visualizing PromQL Queries

PromQL is often used with **Grafana** for visualization. After running a query in Prometheus or Grafana, you can use the results to:

- Create time-series graphs.
- Generate heatmaps.
- Build alerting rules.

---

## Tips for Writing PromQL Queries

1. **Start Simple**:
   Begin with basic queries to retrieve metrics before adding filters or functions.

2. **Use `rate()` Instead of `increase()`**:
   Prefer `rate()` for per-second trends over `increase()` for total values.

3. **Combine Aggregation and Filtering**:
   Aggregate metrics across dimensions but use labels to narrow the focus.

4. **Leverage Documentation**:
   Prometheus's [official documentation](https://prometheus.io/docs/prometheus/latest/querying/basics/) has detailed examples and explanations.

---

## Conclusion

PromQL is a powerful language tailored for real-time metric analysis. By mastering its syntax and functions, you can unlock deep insights into your application's performance and reliability. Practice with real metrics to build confidence and optimize monitoring strategies!
