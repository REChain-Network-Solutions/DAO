# Monitoring Configurations

## Overview

This document provides comprehensive monitoring configurations for the REChain DAO platform, including Prometheus, Grafana, AlertManager, and custom monitoring solutions.

## Table of Contents

1. [Prometheus Configuration](#prometheus-configuration)
2. [Grafana Dashboards](#grafana-dashboards)
3. [AlertManager Rules](#alertmanager-rules)
4. [Custom Metrics](#custom-metrics)
5. [Log Monitoring](#log-monitoring)
6. [Health Checks](#health-checks)

## Prometheus Configuration

### prometheus.yml
```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'rechain-dao'
    environment: 'production'

rule_files:
  - "rules/*.yml"

alerting:
  alertmanagers:
    - static_configs:
        - targets:
          - alertmanager:9093

scrape_configs:
  # Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Kubernetes API server
  - job_name: 'kubernetes-apiservers'
    kubernetes_sd_configs:
      - role: endpoints
    scheme: https
    tls_config:
      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    relabel_configs:
      - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
        action: keep
        regex: default;kubernetes;https

  # Kubernetes nodes
  - job_name: 'kubernetes-nodes'
    kubernetes_sd_configs:
      - role: node
    scheme: https
    tls_config:
      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)

  # Kubernetes pods
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_pod_label_(.+)
      - source_labels: [__meta_kubernetes_namespace]
        action: replace
        target_label: kubernetes_namespace
      - source_labels: [__meta_kubernetes_pod_name]
        action: replace
        target_label: kubernetes_pod_name

  # REChain DAO Application
  - job_name: 'rechain-dao-app'
    kubernetes_sd_configs:
      - role: endpoints
        namespaces:
          names:
            - rechain-dao
    relabel_configs:
      - source_labels: [__meta_kubernetes_service_name]
        action: keep
        regex: rechain-dao-app-service
      - source_labels: [__meta_kubernetes_endpoint_port_name]
        action: keep
        regex: metrics
    metrics_path: /metrics
    scrape_interval: 5s

  # MySQL Exporter
  - job_name: 'mysql'
    static_configs:
      - targets: ['mysql-exporter:9104']
    scrape_interval: 30s

  # Redis Exporter
  - job_name: 'redis'
    static_configs:
      - targets: ['redis-exporter:9121']
    scrape_interval: 30s

  # Node Exporter
  - job_name: 'node-exporter'
    kubernetes_sd_configs:
      - role: endpoints
    relabel_configs:
      - source_labels: [__meta_kubernetes_service_name]
        action: keep
        regex: node-exporter
      - source_labels: [__meta_kubernetes_endpoint_port_name]
        action: keep
        regex: metrics

  # cAdvisor
  - job_name: 'cadvisor'
    kubernetes_sd_configs:
      - role: endpoints
    relabel_configs:
      - source_labels: [__meta_kubernetes_service_name]
        action: keep
        regex: cadvisor
      - source_labels: [__meta_kubernetes_endpoint_port_name]
        action: keep
        regex: metrics
```

### Recording Rules
```yaml
# rules/recording.yml
groups:
  - name: recording_rules
    rules:
      # Application metrics
      - record: rechain_dao:http_requests_per_second
        expr: rate(http_requests_total[5m])
        labels:
          service: "rechain-dao"

      - record: rechain_dao:http_request_duration_seconds_p95
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
        labels:
          service: "rechain-dao"

      - record: rechain_dao:active_connections
        expr: sum(go_goroutines{job="rechain-dao-app"})
        labels:
          service: "rechain-dao"

      # Database metrics
      - record: mysql:connections_utilization
        expr: mysql_global_status_threads_connected / mysql_global_variables_max_connections * 100
        labels:
          service: "mysql"

      - record: mysql:slow_queries_per_second
        expr: rate(mysql_global_status_slow_queries[5m])
        labels:
          service: "mysql"

      # Redis metrics
      - record: redis:memory_utilization
        expr: redis_memory_used_bytes / redis_memory_max_bytes * 100
        labels:
          service: "redis"

      - record: redis:hit_ratio
        expr: redis_keyspace_hits_total / (redis_keyspace_hits_total + redis_keyspace_misses_total) * 100
        labels:
          service: "redis"

      # System metrics
      - record: system:cpu_utilization
        expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
        labels:
          service: "system"

      - record: system:memory_utilization
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
        labels:
          service: "system"

      - record: system:disk_utilization
        expr: (1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100
        labels:
          service: "system"
```

## Grafana Dashboards

### Application Dashboard
```json
{
  "dashboard": {
    "id": null,
    "title": "REChain DAO Application",
    "tags": ["rechain-dao", "application"],
    "timezone": "browser",
    "panels": [
      {
        "id": 1,
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{method}} {{endpoint}}"
          }
        ],
        "yAxes": [
          {
            "label": "Requests/sec",
            "min": 0
          }
        ]
      },
      {
        "id": 2,
        "title": "Response Time",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "95th percentile"
          },
          {
            "expr": "histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "50th percentile"
          }
        ],
        "yAxes": [
          {
            "label": "Seconds",
            "min": 0
          }
        ]
      },
      {
        "id": 3,
        "title": "Error Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total{status=~\"5..\"}[5m])",
            "legendFormat": "5xx errors"
          },
          {
            "expr": "rate(http_requests_total{status=~\"4..\"}[5m])",
            "legendFormat": "4xx errors"
          }
        ],
        "yAxes": [
          {
            "label": "Errors/sec",
            "min": 0
          }
        ]
      },
      {
        "id": 4,
        "title": "Active Connections",
        "type": "singlestat",
        "targets": [
          {
            "expr": "sum(go_goroutines{job=\"rechain-dao-app\"})",
            "legendFormat": "Goroutines"
          }
        ],
        "valueName": "current"
      }
    ],
    "time": {
      "from": "now-1h",
      "to": "now"
    },
    "refresh": "30s"
  }
}
```

### Infrastructure Dashboard
```json
{
  "dashboard": {
    "id": null,
    "title": "REChain DAO Infrastructure",
    "tags": ["rechain-dao", "infrastructure"],
    "panels": [
      {
        "id": 1,
        "title": "CPU Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "100 - (avg by (instance) (rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
            "legendFormat": "{{instance}}"
          }
        ],
        "yAxes": [
          {
            "label": "CPU %",
            "min": 0,
            "max": 100
          }
        ]
      },
      {
        "id": 2,
        "title": "Memory Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100",
            "legendFormat": "{{instance}}"
          }
        ],
        "yAxes": [
          {
            "label": "Memory %",
            "min": 0,
            "max": 100
          }
        ]
      },
      {
        "id": 3,
        "title": "Disk Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "(1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100",
            "legendFormat": "{{instance}} {{mountpoint}}"
          }
        ],
        "yAxes": [
          {
            "label": "Disk %",
            "min": 0,
            "max": 100
          }
        ]
      },
      {
        "id": 4,
        "title": "Network I/O",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(node_network_receive_bytes_total[5m])",
            "legendFormat": "{{instance}} RX"
          },
          {
            "expr": "rate(node_network_transmit_bytes_total[5m])",
            "legendFormat": "{{instance}} TX"
          }
        ],
        "yAxes": [
          {
            "label": "Bytes/sec",
            "min": 0
          }
        ]
      }
    ]
  }
}
```

## AlertManager Rules

### Alert Rules
```yaml
# rules/alerts.yml
groups:
  - name: rechain_dao_alerts
    rules:
      # Application alerts
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 2m
        labels:
          severity: critical
          service: rechain-dao
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value }} errors/sec for {{ $labels.instance }}"

      - alert: HighResponseTime
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
          service: rechain-dao
        annotations:
          summary: "High response time detected"
          description: "95th percentile response time is {{ $value }}s for {{ $labels.instance }}"

      - alert: ApplicationDown
        expr: up{job="rechain-dao-app"} == 0
        for: 1m
        labels:
          severity: critical
          service: rechain-dao
        annotations:
          summary: "Application is down"
          description: "REChain DAO application is not responding"

      # Database alerts
      - alert: MySQLDown
        expr: up{job="mysql"} == 0
        for: 1m
        labels:
          severity: critical
          service: mysql
        annotations:
          summary: "MySQL is down"
          description: "MySQL database is not responding"

      - alert: MySQLHighConnections
        expr: mysql_global_status_threads_connected / mysql_global_variables_max_connections > 0.8
        for: 5m
        labels:
          severity: warning
          service: mysql
        annotations:
          summary: "MySQL high connection usage"
          description: "MySQL connection usage is {{ $value }}%"

      - alert: MySQLSlowQueries
        expr: rate(mysql_global_status_slow_queries[5m]) > 0.1
        for: 5m
        labels:
          severity: warning
          service: mysql
        annotations:
          summary: "MySQL slow queries detected"
          description: "MySQL slow query rate is {{ $value }} queries/sec"

      # Redis alerts
      - alert: RedisDown
        expr: up{job="redis"} == 0
        for: 1m
        labels:
          severity: critical
          service: redis
        annotations:
          summary: "Redis is down"
          description: "Redis cache is not responding"

      - alert: RedisHighMemoryUsage
        expr: redis_memory_used_bytes / redis_memory_max_bytes > 0.9
        for: 5m
        labels:
          severity: warning
          service: redis
        annotations:
          summary: "Redis high memory usage"
          description: "Redis memory usage is {{ $value }}%"

      # System alerts
      - alert: HighCPUUsage
        expr: 100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
          service: system
        annotations:
          summary: "High CPU usage"
          description: "CPU usage is {{ $value }}% on {{ $labels.instance }}"

      - alert: HighMemoryUsage
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 85
        for: 5m
        labels:
          severity: warning
          service: system
        annotations:
          summary: "High memory usage"
          description: "Memory usage is {{ $value }}% on {{ $labels.instance }}"

      - alert: HighDiskUsage
        expr: (1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100 > 90
        for: 5m
        labels:
          severity: critical
          service: system
        annotations:
          summary: "High disk usage"
          description: "Disk usage is {{ $value }}% on {{ $labels.instance }}"
```

### AlertManager Configuration
```yaml
# alertmanager.yml
global:
  smtp_smarthost: 'localhost:587'
  smtp_from: 'alerts@rechain-dao.com'
  smtp_auth_username: 'alerts@rechain-dao.com'
  smtp_auth_password: 'password'

route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'
  routes:
    - match:
        severity: critical
      receiver: 'critical-alerts'
    - match:
        severity: warning
      receiver: 'warning-alerts'

receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'http://127.0.0.1:5001/'

  - name: 'critical-alerts'
    email_configs:
      - to: 'admin@rechain-dao.com'
        subject: '[CRITICAL] {{ .GroupLabels.alertname }}'
        body: |
          {{ range .Alerts }}
          Alert: {{ .Annotations.summary }}
          Description: {{ .Annotations.description }}
          {{ end }}
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/...'
        channel: '#alerts'
        title: 'Critical Alert'
        text: '{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}'

  - name: 'warning-alerts'
    email_configs:
      - to: 'devops@rechain-dao.com'
        subject: '[WARNING] {{ .GroupLabels.alertname }}'
        body: |
          {{ range .Alerts }}
          Alert: {{ .Annotations.summary }}
          Description: {{ .Annotations.description }}
          {{ end }}
```

## Custom Metrics

### Application Metrics
```go
// metrics.go
package main

import (
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promauto"
)

var (
    // HTTP metrics
    httpRequestsTotal = promauto.NewCounterVec(
        prometheus.CounterOpts{
            Name: "http_requests_total",
            Help: "Total number of HTTP requests",
        },
        []string{"method", "endpoint", "status"},
    )

    httpRequestDuration = promauto.NewHistogramVec(
        prometheus.HistogramOpts{
            Name: "http_request_duration_seconds",
            Help: "HTTP request duration in seconds",
            Buckets: prometheus.DefBuckets,
        },
        []string{"method", "endpoint"},
    )

    // Business metrics
    activeUsers = promauto.NewGauge(
        prometheus.GaugeOpts{
            Name: "active_users_total",
            Help: "Number of active users",
        },
    )

    proposalsTotal = promauto.NewCounterVec(
        prometheus.CounterOpts{
            Name: "proposals_total",
            Help: "Total number of proposals",
        },
        []string{"status", "type"},
    )

    votesTotal = promauto.NewCounterVec(
        prometheus.CounterOpts{
            Name: "votes_total",
            Help: "Total number of votes",
        },
        []string{"proposal_id", "vote_type"},
    )

    // Database metrics
    dbConnections = promauto.NewGauge(
        prometheus.GaugeOpts{
            Name: "db_connections_active",
            Help: "Number of active database connections",
        },
    )

    dbQueryDuration = promauto.NewHistogramVec(
        prometheus.HistogramOpts{
            Name: "db_query_duration_seconds",
            Help: "Database query duration in seconds",
            Buckets: prometheus.DefBuckets,
        },
        []string{"query_type"},
    )
)
```

### Custom Collectors
```go
// custom_collectors.go
package main

import (
    "github.com/prometheus/client_golang/prometheus"
)

type CustomCollector struct {
    customMetric *prometheus.Desc
}

func NewCustomCollector() *CustomCollector {
    return &CustomCollector{
        customMetric: prometheus.NewDesc(
            "rechain_dao_custom_metric",
            "A custom metric for REChain DAO",
            []string{"label1", "label2"},
            nil,
        ),
    }
}

func (c *CustomCollector) Describe(ch chan<- *prometheus.Desc) {
    ch <- c.customMetric
}

func (c *CustomCollector) Collect(ch chan<- prometheus.Metric) {
    // Collect your custom metrics here
    value := 1.0
    ch <- prometheus.MustNewConstMetric(
        c.customMetric,
        prometheus.GaugeValue,
        value,
        "value1", "value2",
    )
}
```

## Log Monitoring

### ELK Stack Configuration
```yaml
# logstash.conf
input {
  beats {
    port => 5044
  }
}

filter {
  if [fields][service] == "rechain-dao" {
    grok {
      match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{GREEDYDATA:message}" }
    }
    
    date {
      match => [ "timestamp", "ISO8601" ]
    }
    
    if [level] == "ERROR" {
      mutate {
        add_tag => [ "error" ]
      }
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "rechain-dao-%{+YYYY.MM.dd}"
  }
}
```

### Log Queries
```json
{
  "query": {
    "bool": {
      "must": [
        {
          "range": {
            "@timestamp": {
              "gte": "now-1h"
            }
          }
        },
        {
          "term": {
            "level": "ERROR"
          }
        }
      ]
    }
  }
}
```

## Health Checks

### Application Health Check
```go
// health.go
package main

import (
    "encoding/json"
    "net/http"
    "time"
)

type HealthStatus struct {
    Status    string            `json:"status"`
    Timestamp time.Time         `json:"timestamp"`
    Services  map[string]string `json:"services"`
}

func healthCheck(w http.ResponseWriter, r *http.Request) {
    status := HealthStatus{
        Status:    "healthy",
        Timestamp: time.Now(),
        Services:  make(map[string]string),
    }
    
    // Check database
    if err := checkDatabase(); err != nil {
        status.Services["database"] = "unhealthy"
        status.Status = "unhealthy"
    } else {
        status.Services["database"] = "healthy"
    }
    
    // Check Redis
    if err := checkRedis(); err != nil {
        status.Services["redis"] = "unhealthy"
        status.Status = "unhealthy"
    } else {
        status.Services["redis"] = "healthy"
    }
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(status)
}
```

## Conclusion

These monitoring configurations provide comprehensive observability for the REChain DAO platform, including metrics collection, alerting, and visualization. They ensure proactive monitoring and quick response to issues.

Remember: Regularly review and update monitoring configurations to reflect changes in the application and infrastructure. Monitor the monitoring system itself to ensure it's working correctly.
