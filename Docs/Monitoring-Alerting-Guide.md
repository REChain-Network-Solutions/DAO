# Monitoring and Alerting Guide

## Overview

This comprehensive guide provides system administrators and developers with strategies and tools for monitoring the REChain DAO platform and setting up effective alerting systems.

## Table of Contents

1. [Monitoring Strategy](#monitoring-strategy)
2. [System Metrics](#system-metrics)
3. [Application Metrics](#application-metrics)
4. [Database Monitoring](#database-monitoring)
5. [Log Monitoring](#log-monitoring)
6. [Alerting Configuration](#alerting-configuration)
7. [Dashboard Setup](#dashboard-setup)
8. [Incident Response](#incident-response)
9. [Performance Monitoring](#performance-monitoring)
10. [Security Monitoring](#security-monitoring)
11. [Best Practices](#best-practices)

## Monitoring Strategy

### Monitoring Layers

#### Infrastructure Monitoring
- **Server Health**: CPU, memory, disk, network
- **Service Status**: Web server, database, cache, background jobs
- **Resource Usage**: Storage, bandwidth, connection pools
- **Availability**: Uptime, response times, error rates

#### Application Monitoring
- **Performance**: Response times, throughput, error rates
- **Business Metrics**: User registrations, posts, transactions
- **User Experience**: Page load times, user flows, conversions
- **Code Quality**: Error rates, exception tracking, code coverage

#### Security Monitoring
- **Authentication**: Failed logins, suspicious activity
- **Authorization**: Permission violations, privilege escalations
- **Network Security**: DDoS attacks, malicious traffic
- **Data Security**: Data breaches, unauthorized access

### Monitoring Tools

#### Prometheus + Grafana Stack
```yaml
# docker-compose.monitoring.yml
version: '3.8'
services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin

  node-exporter:
    image: prom/node-exporter:latest
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'

  mysql-exporter:
    image: prom/mysqld-exporter:latest
    ports:
      - "9104:9104"
    environment:
      - DATA_SOURCE_NAME=monitor:password@(mysql:3306)/

volumes:
  prometheus_data:
  grafana_data:
```

## System Metrics

### Server Metrics

#### CPU Monitoring
```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
    scrape_interval: 5s

  - job_name: 'mysql-exporter'
    static_configs:
      - targets: ['mysql-exporter:9104']
    scrape_interval: 5s

  - job_name: 'rechain-dao-app'
    static_configs:
      - targets: ['app:80']
    scrape_interval: 5s
    metrics_path: '/metrics'
```

#### Memory Monitoring
```promql
# CPU usage
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))

# Disk usage
100 * (1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes))

# Network traffic
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])
```

### Service Health Checks

#### Health Check Endpoints
```php
// Health check controller
class HealthCheckController {
    public function systemHealth() {
        $checks = [
            'database' => $this->checkDatabase(),
            'redis' => $this->checkRedis(),
            'storage' => $this->checkStorage(),
            'external_apis' => $this->checkExternalAPIs()
        ];
        
        $overall_health = !in_array(false, $checks);
        
        return response()->json([
            'status' => $overall_health ? 'healthy' : 'unhealthy',
            'checks' => $checks,
            'timestamp' => now()->toISOString()
        ], $overall_health ? 200 : 503);
    }
    
    private function checkDatabase() {
        try {
            DB::connection()->getPdo();
            return true;
        } catch (Exception $e) {
            return false;
        }
    }
    
    private function checkRedis() {
        try {
            Redis::ping();
            return true;
        } catch (Exception $e) {
            return false;
        }
    }
    
    private function checkStorage() {
        try {
            $test_file = 'health_check_' . time() . '.txt';
            Storage::put($test_file, 'test');
            Storage::delete($test_file);
            return true;
        } catch (Exception $e) {
            return false;
        }
    }
    
    private function checkExternalAPIs() {
        $apis = [
            'stripe' => 'https://api.stripe.com/v1/charges',
            'sendgrid' => 'https://api.sendgrid.com/v3/mail/send'
        ];
        
        $results = [];
        foreach ($apis as $name => $url) {
            $results[$name] = $this->checkExternalAPI($url);
        }
        
        return $results;
    }
    
    private function checkExternalAPI($url) {
        try {
            $response = Http::timeout(5)->get($url);
            return $response->status() < 500;
        } catch (Exception $e) {
            return false;
        }
    }
}
```

## Application Metrics

### Custom Metrics

#### Application Metrics Collection
```php
// Custom metrics collector
class MetricsCollector {
    private $prometheus;
    
    public function __construct() {
        $this->prometheus = new Prometheus();
    }
    
    public function recordRequest($method, $endpoint, $status_code, $duration) {
        $counter = $this->prometheus->getOrRegisterCounter(
            'http_requests_total',
            'Total HTTP requests',
            ['method', 'endpoint', 'status_code']
        );
        
        $counter->inc([
            $method,
            $endpoint,
            $status_code
        ]);
        
        $histogram = $this->prometheus->getOrRegisterHistogram(
            'http_request_duration_seconds',
            'HTTP request duration',
            ['method', 'endpoint'],
            [0.1, 0.5, 1.0, 2.5, 5.0, 10.0]
        );
        
        $histogram->observe($duration, [$method, $endpoint]);
    }
    
    public function recordUserRegistration() {
        $counter = $this->prometheus->getOrRegisterCounter(
            'user_registrations_total',
            'Total user registrations'
        );
        
        $counter->inc();
    }
    
    public function recordPostCreation($post_type) {
        $counter = $this->prometheus->getOrRegisterCounter(
            'posts_created_total',
            'Total posts created',
            ['post_type']
        );
        
        $counter->inc([$post_type]);
    }
    
    public function recordDatabaseQuery($query_type, $duration) {
        $histogram = $this->prometheus->getOrRegisterHistogram(
            'database_query_duration_seconds',
            'Database query duration',
            ['query_type'],
            [0.01, 0.05, 0.1, 0.5, 1.0, 5.0]
        );
        
        $histogram->observe($duration, [$query_type]);
    }
}
```

#### Middleware for Metrics
```php
// Metrics middleware
class MetricsMiddleware {
    private $metrics;
    
    public function __construct(MetricsCollector $metrics) {
        $this->metrics = $metrics;
    }
    
    public function handle($request, Closure $next) {
        $start_time = microtime(true);
        
        $response = $next($request);
        
        $duration = microtime(true) - $start_time;
        
        $this->metrics->recordRequest(
            $request->method(),
            $request->path(),
            $response->getStatusCode(),
            $duration
        );
        
        return $response;
    }
}
```

### Business Metrics

#### User Metrics
```php
// User metrics tracking
class UserMetrics {
    private $metrics;
    
    public function __construct(MetricsCollector $metrics) {
        $this->metrics = $metrics;
    }
    
    public function trackUserRegistration($user_id) {
        $this->metrics->recordUserRegistration();
        
        // Track user demographics
        $user = User::find($user_id);
        $this->trackUserDemographics($user);
    }
    
    public function trackUserLogin($user_id) {
        $counter = $this->metrics->getOrRegisterCounter(
            'user_logins_total',
            'Total user logins'
        );
        
        $counter->inc();
    }
    
    public function trackUserActivity($user_id, $activity_type) {
        $counter = $this->metrics->getOrRegisterCounter(
            'user_activities_total',
            'Total user activities',
            ['activity_type']
        );
        
        $counter->inc([$activity_type]);
    }
    
    private function trackUserDemographics($user) {
        $gauge = $this->metrics->getOrRegisterGauge(
            'user_demographics',
            'User demographics',
            ['gender', 'age_group']
        );
        
        $age_group = $this->getAgeGroup($user->user_birthdate);
        $gauge->set(1, [$user->user_gender, $age_group]);
    }
    
    private function getAgeGroup($birthdate) {
        $age = Carbon::parse($birthdate)->age;
        
        if ($age < 18) return 'under_18';
        if ($age < 25) return '18_24';
        if ($age < 35) return '25_34';
        if ($age < 45) return '35_44';
        if ($age < 55) return '45_54';
        return '55_plus';
    }
}
```

## Database Monitoring

### MySQL Monitoring

#### MySQL Metrics
```yaml
# mysql-exporter configuration
mysql_exporter:
  data_source_name: "monitor:password@(mysql:3306)/"
  log_level: "info"
  web_listen_address: ":9104"
  web_telemetry_path: "/metrics"
```

#### Database Performance Queries
```sql
-- Slow query monitoring
SELECT 
    query_time,
    lock_time,
    rows_sent,
    rows_examined,
    sql_text,
    user_host,
    timestamp
FROM mysql.slow_log 
WHERE query_time > 1
ORDER BY query_time DESC 
LIMIT 10;

-- Connection monitoring
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Max_used_connections';
SHOW STATUS LIKE 'Connections';

-- InnoDB monitoring
SHOW STATUS LIKE 'Innodb_buffer_pool%';
SHOW STATUS LIKE 'Innodb_log%';
SHOW STATUS LIKE 'Innodb_row_lock%';

-- Query cache monitoring
SHOW STATUS LIKE 'Qcache%';
SHOW VARIABLES LIKE 'query_cache%';
```

#### Database Alerts
```yaml
# Database alert rules
groups:
  - name: database
    rules:
      - alert: HighConnections
        expr: mysql_global_status_threads_connected / mysql_global_variables_max_connections > 0.8
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High database connections"
          description: "Database connections are at {{ $value | humanizePercentage }} of maximum"
      
      - alert: SlowQueries
        expr: rate(mysql_global_status_slow_queries[5m]) > 0.1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High slow query rate"
          description: "Slow query rate is {{ $value }} queries per second"
      
      - alert: DatabaseDown
        expr: mysql_up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Database is down"
          description: "MySQL database is not responding"
```

## Log Monitoring

### Log Aggregation

#### ELK Stack Setup
```yaml
# docker-compose.logging.yml
version: '3.8'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.8.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - "9200:9200"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data

  logstash:
    image: docker.elastic.co/logstash/logstash:8.8.0
    ports:
      - "5044:5044"
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    depends_on:
      - elasticsearch

  kibana:
    image: docker.elastic.co/kibana/kibana:8.8.0
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    depends_on:
      - elasticsearch

  filebeat:
    image: docker.elastic.co/beats/filebeat:8.8.0
    volumes:
      - ./filebeat.yml:/usr/share/filebeat/filebeat.yml
      - /var/log:/var/log:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
    depends_on:
      - logstash

volumes:
  elasticsearch_data:
```

#### Logstash Configuration
```ruby
# logstash.conf
input {
  beats {
    port => 5044
  }
}

filter {
  if [fields][log_type] == "apache" {
    grok {
      match => { "message" => "%{COMBINEDAPACHELOG}" }
    }
    date {
      match => [ "timestamp", "dd/MMM/yyyy:HH:mm:ss Z" ]
    }
  }
  
  if [fields][log_type] == "php" {
    grok {
      match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{LOGLEVEL:level} %{GREEDYDATA:message}" }
    }
    date {
      match => [ "timestamp", "ISO8601" ]
    }
  }
  
  if [fields][log_type] == "mysql" {
    grok {
      match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} %{NUMBER:thread_id} %{WORD:level} %{GREEDYDATA:message}" }
    }
    date {
      match => [ "timestamp", "ISO8601" ]
    }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "logs-%{+YYYY.MM.dd}"
  }
}
```

### Application Logging

#### Structured Logging
```php
// Structured logging implementation
class StructuredLogger {
    private $logger;
    
    public function __construct() {
        $this->logger = new Logger('rechain-dao');
        $this->setupHandlers();
    }
    
    private function setupHandlers() {
        $handler = new StreamHandler(storage_path('logs/app.log'));
        $formatter = new JsonFormatter();
        $handler->setFormatter($formatter);
        $this->logger->pushHandler($handler);
    }
    
    public function logUserAction($user_id, $action, $context = []) {
        $this->logger->info('User action', [
            'user_id' => $user_id,
            'action' => $action,
            'context' => $context,
            'timestamp' => now()->toISOString(),
            'ip_address' => request()->ip(),
            'user_agent' => request()->userAgent()
        ]);
    }
    
    public function logSecurityEvent($event_type, $details = []) {
        $this->logger->warning('Security event', [
            'event_type' => $event_type,
            'details' => $details,
            'timestamp' => now()->toISOString(),
            'ip_address' => request()->ip(),
            'user_agent' => request()->userAgent()
        ]);
    }
    
    public function logPerformance($operation, $duration, $context = []) {
        $this->logger->info('Performance metric', [
            'operation' => $operation,
            'duration' => $duration,
            'context' => $context,
            'timestamp' => now()->toISOString()
        ]);
    }
    
    public function logError($error, $context = []) {
        $this->logger->error('Application error', [
            'error' => $error,
            'context' => $context,
            'timestamp' => now()->toISOString(),
            'ip_address' => request()->ip(),
            'user_agent' => request()->userAgent()
        ]);
    }
}
```

## Alerting Configuration

### Alert Rules

#### Prometheus Alert Rules
```yaml
# alert-rules.yml
groups:
  - name: system
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is above 80% for more than 5 minutes"
      
      - alert: HighMemoryUsage
        expr: 100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage on {{ $labels.instance }}"
          description: "Memory usage is above 85% for more than 5 minutes"
      
      - alert: DiskSpaceLow
        expr: 100 * (1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) > 90
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Disk space low on {{ $labels.instance }}"
          description: "Disk usage is above 90% for more than 5 minutes"
  
  - name: application
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status_code=~"5.."}[5m]) / rate(http_requests_total[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High error rate"
          description: "Error rate is above 5% for more than 5 minutes"
      
      - alert: HighResponseTime
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High response time"
          description: "95th percentile response time is above 2 seconds"
      
      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Service is down"
          description: "{{ $labels.job }} service is not responding"
```

### Alert Manager

#### Alert Manager Configuration
```yaml
# alertmanager.yml
global:
  smtp_smarthost: 'localhost:587'
  smtp_from: 'alerts@rechain.network'

route:
  group_by: ['alertname']
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
      - url: 'http://localhost:5001/'

  - name: 'critical-alerts'
    email_configs:
      - to: 'admin@rechain.network'
        subject: 'CRITICAL: {{ .GroupLabels.alertname }}'
        body: |
          {{ range .Alerts }}
          Alert: {{ .Annotations.summary }}
          Description: {{ .Annotations.description }}
          {{ end }}
    slack_configs:
      - api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'
        channel: '#alerts'
        title: 'CRITICAL Alert'
        text: '{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}'

  - name: 'warning-alerts'
    email_configs:
      - to: 'team@rechain.network'
        subject: 'WARNING: {{ .GroupLabels.alertname }}'
        body: |
          {{ range .Alerts }}
          Alert: {{ .Annotations.summary }}
          Description: {{ .Annotations.description }}
          {{ end }}
```

## Dashboard Setup

### Grafana Dashboards

#### System Dashboard
```json
{
  "dashboard": {
    "title": "System Overview",
    "panels": [
      {
        "title": "CPU Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
            "legendFormat": "{{instance}}"
          }
        ]
      },
      {
        "title": "Memory Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))",
            "legendFormat": "{{instance}}"
          }
        ]
      },
      {
        "title": "Disk Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "100 * (1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes))",
            "legendFormat": "{{instance}} - {{mountpoint}}"
          }
        ]
      }
    ]
  }
}
```

#### Application Dashboard
```json
{
  "dashboard": {
    "title": "Application Metrics",
    "panels": [
      {
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{method}} {{endpoint}}"
          }
        ]
      },
      {
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
        ]
      },
      {
        "title": "Error Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total{status_code=~\"5..\"}[5m]) / rate(http_requests_total[5m])",
            "legendFormat": "Error Rate"
          }
        ]
      }
    ]
  }
}
```

## Incident Response

### Incident Management

#### Incident Response Process
```php
// Incident management system
class IncidentManager {
    private $logger;
    private $notification_service;
    
    public function __construct() {
        $this->logger = new StructuredLogger();
        $this->notification_service = new NotificationService();
    }
    
    public function handleAlert($alert) {
        $incident = $this->createIncident($alert);
        
        // Log the incident
        $this->logger->logSecurityEvent('incident_created', [
            'incident_id' => $incident->id,
            'alert_type' => $alert['type'],
            'severity' => $alert['severity']
        ]);
        
        // Notify team
        $this->notifyTeam($incident);
        
        // Auto-remediate if possible
        if ($this->canAutoRemediate($alert)) {
            $this->autoRemediate($incident);
        }
        
        return $incident;
    }
    
    private function createIncident($alert) {
        return Incident::create([
            'title' => $alert['summary'],
            'description' => $alert['description'],
            'severity' => $alert['severity'],
            'status' => 'open',
            'created_at' => now()
        ]);
    }
    
    private function notifyTeam($incident) {
        $message = "🚨 Incident #{$incident->id}: {$incident->title}";
        
        $this->notification_service->sendSlackMessage('#alerts', $message);
        $this->notification_service->sendEmail('team@rechain.network', $message);
    }
    
    private function canAutoRemediate($alert) {
        $auto_remediable = [
            'HighCPUUsage',
            'HighMemoryUsage',
            'ServiceDown'
        ];
        
        return in_array($alert['type'], $auto_remediable);
    }
    
    private function autoRemediate($incident) {
        // Implement auto-remediation logic
        $this->logger->logSecurityEvent('auto_remediation_attempted', [
            'incident_id' => $incident->id
        ]);
    }
}
```

### Runbook Automation

#### Automated Runbooks
```yaml
# runbooks.yml
runbooks:
  - name: "High CPU Usage"
    triggers:
      - alert: "HighCPUUsage"
    steps:
      - name: "Check top processes"
        command: "top -bn1 | head -20"
      - name: "Check system load"
        command: "uptime"
      - name: "Check memory usage"
        command: "free -h"
      - name: "Restart high CPU services"
        command: "systemctl restart apache2"
        condition: "cpu_usage > 90"
  
  - name: "Database Connection Issues"
    triggers:
      - alert: "DatabaseDown"
    steps:
      - name: "Check MySQL status"
        command: "systemctl status mysql"
      - name: "Check MySQL logs"
        command: "tail -50 /var/log/mysql/error.log"
      - name: "Restart MySQL"
        command: "systemctl restart mysql"
      - name: "Verify connection"
        command: "mysql -e 'SELECT 1'"
```

## Performance Monitoring

### APM Integration

#### Application Performance Monitoring
```php
// APM integration
class APMService {
    private $tracer;
    
    public function __construct() {
        $this->tracer = new Tracer();
    }
    
    public function startTransaction($name, $type = 'web') {
        $transaction = $this->tracer->startTransaction($name, $type);
        return $transaction;
    }
    
    public function startSpan($name, $transaction) {
        $span = $transaction->startSpan($name);
        return $span;
    }
    
    public function endSpan($span) {
        $span->end();
    }
    
    public function endTransaction($transaction) {
        $transaction->end();
    }
    
    public function addCustomContext($key, $value) {
        $this->tracer->addCustomContext($key, $value);
    }
}
```

#### Performance Middleware
```php
// Performance monitoring middleware
class PerformanceMiddleware {
    private $apm;
    
    public function __construct(APMService $apm) {
        $this->apm = $apm;
    }
    
    public function handle($request, Closure $next) {
        $transaction = $this->apm->startTransaction(
            $request->method() . ' ' . $request->path(),
            'web'
        );
        
        $this->apm->addCustomContext('user_id', auth()->id());
        $this->apm->addCustomContext('ip_address', $request->ip());
        
        $response = $next($request);
        
        $transaction->setResult($response->getStatusCode());
        $this->apm->endTransaction($transaction);
        
        return $response;
    }
}
```

## Security Monitoring

### Security Event Detection

#### Security Monitoring Rules
```yaml
# security-alerts.yml
groups:
  - name: security
    rules:
      - alert: FailedLoginAttempts
        expr: rate(failed_logins_total[5m]) > 5
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "High failed login attempts"
          description: "Failed login rate is {{ $value }} attempts per second"
      
      - alert: SuspiciousActivity
        expr: rate(suspicious_activities_total[5m]) > 1
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Suspicious activity detected"
          description: "Suspicious activity rate is {{ $value }} events per second"
      
      - alert: UnauthorizedAccess
        expr: rate(unauthorized_access_attempts_total[5m]) > 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Unauthorized access attempt"
          description: "Unauthorized access attempt detected"
```

#### Security Event Tracking
```php
// Security event tracking
class SecurityMonitor {
    private $metrics;
    private $logger;
    
    public function __construct(MetricsCollector $metrics, StructuredLogger $logger) {
        $this->metrics = $metrics;
        $this->logger = $logger;
    }
    
    public function trackFailedLogin($email, $ip_address) {
        $this->metrics->recordCounter('failed_logins_total');
        
        $this->logger->logSecurityEvent('failed_login', [
            'email' => $email,
            'ip_address' => $ip_address,
            'timestamp' => now()->toISOString()
        ]);
        
        // Check for brute force attempts
        $this->checkBruteForceAttempts($ip_address);
    }
    
    public function trackSuspiciousActivity($user_id, $activity_type, $details) {
        $this->metrics->recordCounter('suspicious_activities_total');
        
        $this->logger->logSecurityEvent('suspicious_activity', [
            'user_id' => $user_id,
            'activity_type' => $activity_type,
            'details' => $details,
            'timestamp' => now()->toISOString()
        ]);
    }
    
    public function trackUnauthorizedAccess($user_id, $resource, $action) {
        $this->metrics->recordCounter('unauthorized_access_attempts_total');
        
        $this->logger->logSecurityEvent('unauthorized_access', [
            'user_id' => $user_id,
            'resource' => $resource,
            'action' => $action,
            'timestamp' => now()->toISOString()
        ]);
    }
    
    private function checkBruteForceAttempts($ip_address) {
        $attempts = $this->getFailedLoginAttempts($ip_address, 300); // 5 minutes
        
        if ($attempts > 10) {
            $this->blockIP($ip_address);
            $this->logger->logSecurityEvent('ip_blocked', [
                'ip_address' => $ip_address,
                'reason' => 'brute_force_attempts',
                'attempts' => $attempts
            ]);
        }
    }
}
```

## Best Practices

### Monitoring Best Practices

#### Metric Design
1. **Use Descriptive Names**: Choose clear, descriptive metric names
2. **Include Labels**: Use labels to provide context and enable filtering
3. **Avoid High Cardinality**: Don't use high-cardinality labels
4. **Use Appropriate Types**: Choose the right metric type (counter, gauge, histogram)

#### Alert Design
1. **Set Appropriate Thresholds**: Use realistic thresholds based on historical data
2. **Use Multiple Conditions**: Combine multiple conditions to reduce false positives
3. **Set Proper Durations**: Use appropriate durations to avoid alert fatigue
4. **Provide Context**: Include relevant context in alert messages

#### Dashboard Design
1. **Focus on Key Metrics**: Show the most important metrics prominently
2. **Use Appropriate Visualizations**: Choose the right chart type for each metric
3. **Group Related Metrics**: Organize related metrics together
4. **Keep It Simple**: Avoid cluttering dashboards with too many panels

### Operational Best Practices

#### Incident Response
1. **Have Clear Procedures**: Document incident response procedures
2. **Test Regularly**: Regularly test incident response procedures
3. **Learn from Incidents**: Conduct post-incident reviews
4. **Improve Continuously**: Use incident data to improve monitoring

#### Maintenance
1. **Regular Reviews**: Regularly review and update monitoring configurations
2. **Clean Up**: Remove unused metrics and alerts
3. **Document Changes**: Document all monitoring changes
4. **Train Team**: Ensure team members understand monitoring systems

## Conclusion

This monitoring and alerting guide provides comprehensive strategies for monitoring the REChain DAO platform effectively. Proper monitoring and alerting are essential for maintaining a reliable and performant platform.

Remember: Monitoring is not just about collecting metrics; it's about using those metrics to make informed decisions and take proactive action to prevent issues before they impact users.
