# Kubernetes Manifests

## Overview

This document provides comprehensive Kubernetes manifests for deploying the REChain DAO platform, including deployments, services, configmaps, secrets, and ingress configurations.

## Table of Contents

1. [Namespace and RBAC](#namespace-and-rbac)
2. [ConfigMaps and Secrets](#configmaps-and-secrets)
3. [Database Deployment](#database-deployment)
4. [Application Deployment](#application-deployment)
5. [Services and Ingress](#services-and-ingress)
6. [Monitoring and Logging](#monitoring-and-logging)
7. [Backup and Recovery](#backup-and-recovery)

## Namespace and RBAC

### Namespace
```yaml
# namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: rechain-dao
  labels:
    name: rechain-dao
    environment: production
---
apiVersion: v1
kind: Namespace
metadata:
  name: rechain-dao-staging
  labels:
    name: rechain-dao-staging
    environment: staging
```

### RBAC Configuration
```yaml
# rbac.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: rechain-dao-sa
  namespace: rechain-dao
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: rechain-dao
  name: rechain-dao-role
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "secrets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: rechain-dao-rolebinding
  namespace: rechain-dao
subjects:
- kind: ServiceAccount
  name: rechain-dao-sa
  namespace: rechain-dao
roleRef:
  kind: Role
  name: rechain-dao-role
  apiGroup: rbac.authorization.k8s.io
```

## ConfigMaps and Secrets

### Application ConfigMap
```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: rechain-dao-config
  namespace: rechain-dao
data:
  NODE_ENV: "production"
  PORT: "8000"
  LOG_LEVEL: "info"
  
  # Database configuration
  DB_HOST: "mysql-service"
  DB_PORT: "3306"
  DB_NAME: "rechain_dao"
  
  # Redis configuration
  REDIS_HOST: "redis-service"
  REDIS_PORT: "6379"
  
  # JWT configuration
  JWT_EXPIRES_IN: "1h"
  
  # Email configuration
  SMTP_PORT: "587"
  SMTP_ENCRYPTION: "tls"
  
  # Blockchain configuration
  BLOCKCHAIN_NETWORK: "mainnet"
  GAS_LIMIT: "21000"
  
  # Monitoring configuration
  METRICS_ENABLED: "true"
  METRICS_PORT: "9090"
  
  # Security configuration
  RATE_LIMITING_ENABLED: "true"
  RATE_LIMITING_REQUESTS_PER_MINUTE: "100"
  RATE_LIMITING_BURST_SIZE: "200"
  
  # CORS configuration
  CORS_ENABLED: "true"
  CORS_ALLOWED_ORIGINS: "https://rechain-dao.com"
  CORS_ALLOWED_METHODS: "GET,POST,PUT,DELETE"
  CORS_ALLOWED_HEADERS: "Content-Type,Authorization"
```

### Secrets
```yaml
# secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: rechain-dao-secrets
  namespace: rechain-dao
type: Opaque
data:
  # Base64 encoded values
  DB_PASSWORD: <base64-encoded-password>
  DB_ROOT_PASSWORD: <base64-encoded-root-password>
  REDIS_PASSWORD: <base64-encoded-redis-password>
  JWT_SECRET: <base64-encoded-jwt-secret>
  SMTP_USERNAME: <base64-encoded-smtp-username>
  SMTP_PASSWORD: <base64-encoded-smtp-password>
  BLOCKCHAIN_PRIVATE_KEY: <base64-encoded-private-key>
  AWS_ACCESS_KEY_ID: <base64-encoded-aws-access-key>
  AWS_SECRET_ACCESS_KEY: <base64-encoded-aws-secret-key>
  GITHUB_TOKEN: <base64-encoded-github-token>
---
apiVersion: v1
kind: Secret
metadata:
  name: rechain-dao-tls
  namespace: rechain-dao
type: kubernetes.io/tls
data:
  tls.crt: <base64-encoded-certificate>
  tls.key: <base64-encoded-private-key>
```

## Database Deployment

### MySQL Deployment
```yaml
# mysql-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
  namespace: rechain-dao
  labels:
    app: mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        ports:
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: rechain-dao-secrets
              key: DB_ROOT_PASSWORD
        - name: MYSQL_DATABASE
          valueFrom:
            configMapKeyRef:
              name: rechain-dao-config
              key: DB_NAME
        - name: MYSQL_USER
          value: "rechain"
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: rechain-dao-secrets
              key: DB_PASSWORD
        volumeMounts:
        - name: mysql-storage
          mountPath: /var/lib/mysql
        - name: mysql-config
          mountPath: /etc/mysql/conf.d
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
        livenessProbe:
          exec:
            command:
            - mysqladmin
            - ping
            - -h
            - localhost
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
            - mysql
            - -h
            - localhost
            - -u
            - root
            - -p$MYSQL_ROOT_PASSWORD
            - -e
            - "SELECT 1"
          initialDelaySeconds: 5
          periodSeconds: 2
      volumes:
      - name: mysql-storage
        persistentVolumeClaim:
          claimName: mysql-pvc
      - name: mysql-config
        configMap:
          name: mysql-config
---
apiVersion: v1
kind: Service
metadata:
  name: mysql-service
  namespace: rechain-dao
spec:
  selector:
    app: mysql
  ports:
  - port: 3306
    targetPort: 3306
  type: ClusterIP
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
  namespace: rechain-dao
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  storageClassName: gp2
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config
  namespace: rechain-dao
data:
  my.cnf: |
    [mysqld]
    character-set-server=utf8mb4
    collation-server=utf8mb4_unicode_ci
    default-time-zone='+00:00'
    sql_mode=STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO
    
    # Performance tuning
    innodb_buffer_pool_size=1G
    innodb_log_file_size=256M
    innodb_flush_log_at_trx_commit=2
    innodb_flush_method=O_DIRECT
    
    # Connection settings
    max_connections=200
    max_connect_errors=1000
    wait_timeout=28800
    interactive_timeout=28800
    
    # Logging
    slow_query_log=1
    slow_query_log_file=/var/lib/mysql/slow.log
    long_query_time=2
```

### Redis Deployment
```yaml
# redis-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
  namespace: rechain-dao
  labels:
    app: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - name: redis
        image: redis:7-alpine
        ports:
        - containerPort: 6379
        env:
        - name: REDIS_PASSWORD
          valueFrom:
            secretKeyRef:
              name: rechain-dao-secrets
              key: REDIS_PASSWORD
        command:
        - redis-server
        - --requirepass
        - $(REDIS_PASSWORD)
        - --appendonly
        - "yes"
        volumeMounts:
        - name: redis-storage
          mountPath: /data
        resources:
          requests:
            memory: "256Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "200m"
        livenessProbe:
          exec:
            command:
            - redis-cli
            - -a
            - $(REDIS_PASSWORD)
            - ping
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
            - redis-cli
            - -a
            - $(REDIS_PASSWORD)
            - ping
          initialDelaySeconds: 5
          periodSeconds: 2
      volumes:
      - name: redis-storage
        persistentVolumeClaim:
          claimName: redis-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: redis-service
  namespace: rechain-dao
spec:
  selector:
    app: redis
  ports:
  - port: 6379
    targetPort: 6379
  type: ClusterIP
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-pvc
  namespace: rechain-dao
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: gp2
```

## Application Deployment

### Main Application Deployment
```yaml
# app-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rechain-dao-app
  namespace: rechain-dao
  labels:
    app: rechain-dao-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rechain-dao-app
  template:
    metadata:
      labels:
        app: rechain-dao-app
    spec:
      serviceAccountName: rechain-dao-sa
      containers:
      - name: rechain-dao-app
        image: rechain-dao:latest
        ports:
        - containerPort: 8000
          name: http
        - containerPort: 9090
          name: metrics
        env:
        - name: NODE_ENV
          valueFrom:
            configMapKeyRef:
              name: rechain-dao-config
              key: NODE_ENV
        - name: PORT
          valueFrom:
            configMapKeyRef:
              name: rechain-dao-config
              key: PORT
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: rechain-dao-config
              key: DB_HOST
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: rechain-dao-secrets
              key: DB_PASSWORD
        - name: JWT_SECRET
          valueFrom:
            secretKeyRef:
              name: rechain-dao-secrets
              key: JWT_SECRET
        volumeMounts:
        - name: app-storage
          mountPath: /app/storage
        - name: app-logs
          mountPath: /app/logs
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          initialDelaySeconds: 5
          periodSeconds: 2
      volumes:
      - name: app-storage
        persistentVolumeClaim:
          claimName: app-storage-pvc
      - name: app-logs
        persistentVolumeClaim:
          claimName: app-logs-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: rechain-dao-app-service
  namespace: rechain-dao
spec:
  selector:
    app: rechain-dao-app
  ports:
  - name: http
    port: 8000
    targetPort: 8000
  - name: metrics
    port: 9090
    targetPort: 9090
  type: ClusterIP
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-storage-pvc
  namespace: rechain-dao
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 10Gi
  storageClassName: gp2
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-logs-pvc
  namespace: rechain-dao
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 5Gi
  storageClassName: gp2
```

### Horizontal Pod Autoscaler
```yaml
# hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: rechain-dao-hpa
  namespace: rechain-dao
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: rechain-dao-app
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
      - type: Pods
        value: 2
        periodSeconds: 60
      - type: Percent
        value: 100
        periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Pods
        value: 1
        periodSeconds: 60
```

## Services and Ingress

### Services
```yaml
# services.yaml
apiVersion: v1
kind: Service
metadata:
  name: rechain-dao-service
  namespace: rechain-dao
  labels:
    app: rechain-dao
spec:
  selector:
    app: rechain-dao-app
  ports:
  - name: http
    port: 80
    targetPort: 8000
    protocol: TCP
  - name: https
    port: 443
    targetPort: 8000
    protocol: TCP
  type: ClusterIP
---
apiVersion: v1
kind: Service
metadata:
  name: rechain-dao-metrics
  namespace: rechain-dao
  labels:
    app: rechain-dao-metrics
spec:
  selector:
    app: rechain-dao-app
  ports:
  - name: metrics
    port: 9090
    targetPort: 9090
    protocol: TCP
  type: ClusterIP
```

### Ingress Configuration
```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rechain-dao-ingress
  namespace: rechain-dao
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/proxy-body-size: "10m"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "300"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "300"
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - api.rechain-dao.com
    - rechain-dao.com
    secretName: rechain-dao-tls
  rules:
  - host: api.rechain-dao.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: rechain-dao-service
            port:
              number: 80
  - host: rechain-dao.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: rechain-dao-service
            port:
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rechain-dao-metrics-ingress
  namespace: rechain-dao
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: basic-auth
    nginx.ingress.kubernetes.io/auth-realm: "Authentication Required"
spec:
  tls:
  - hosts:
    - metrics.rechain-dao.com
    secretName: rechain-dao-tls
  rules:
  - host: metrics.rechain-dao.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: rechain-dao-metrics
            port:
              number: 9090
```

## Monitoring and Logging

### Prometheus Configuration
```yaml
# prometheus.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: rechain-dao
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s
    
    rule_files:
      - "rules/*.yml"
    
    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
          - targets: ['localhost:9090']
      
      - job_name: 'rechain-dao-app'
        static_configs:
          - targets: ['rechain-dao-metrics:9090']
        metrics_path: '/metrics'
        scrape_interval: 5s
      
      - job_name: 'mysql'
        static_configs:
          - targets: ['mysql-exporter:9104']
      
      - job_name: 'redis'
        static_configs:
          - targets: ['redis-exporter:9121']
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: rechain-dao
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus:latest
        ports:
        - containerPort: 9090
        volumeMounts:
        - name: prometheus-config
          mountPath: /etc/prometheus
        - name: prometheus-storage
          mountPath: /prometheus
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
      volumes:
      - name: prometheus-config
        configMap:
          name: prometheus-config
      - name: prometheus-storage
        persistentVolumeClaim:
          claimName: prometheus-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus-service
  namespace: rechain-dao
spec:
  selector:
    app: prometheus
  ports:
  - port: 9090
    targetPort: 9090
  type: ClusterIP
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-pvc
  namespace: rechain-dao
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: gp2
```

### Grafana Configuration
```yaml
# grafana.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: rechain-dao
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:latest
        ports:
        - containerPort: 3000
        env:
        - name: GF_SECURITY_ADMIN_PASSWORD
          valueFrom:
            secretKeyRef:
              name: grafana-secrets
              key: admin-password
        volumeMounts:
        - name: grafana-storage
          mountPath: /var/lib/grafana
        - name: grafana-config
          mountPath: /etc/grafana/provisioning
        resources:
          requests:
            memory: "256Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "200m"
      volumes:
      - name: grafana-storage
        persistentVolumeClaim:
          claimName: grafana-pvc
      - name: grafana-config
        configMap:
          name: grafana-config
---
apiVersion: v1
kind: Service
metadata:
  name: grafana-service
  namespace: rechain-dao
spec:
  selector:
    app: grafana
  ports:
  - port: 3000
    targetPort: 3000
  type: ClusterIP
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: grafana-pvc
  namespace: rechain-dao
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
  storageClassName: gp2
---
apiVersion: v1
kind: Secret
metadata:
  name: grafana-secrets
  namespace: rechain-dao
type: Opaque
data:
  admin-password: <base64-encoded-password>
```

## Backup and Recovery

### Database Backup Job
```yaml
# backup-job.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: mysql-backup
  namespace: rechain-dao
spec:
  schedule: "0 2 * * *"  # Daily at 2 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: mysql-backup
            image: mysql:8.0
            command:
            - /bin/bash
            - -c
            - |
              mysqldump -h mysql-service -u root -p$MYSQL_ROOT_PASSWORD --all-databases > /backup/mysql-backup-$(date +%Y%m%d_%H%M%S).sql
              aws s3 cp /backup/mysql-backup-$(date +%Y%m%d_%H%M%S).sql s3://rechain-dao-backups/mysql/
            env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: rechain-dao-secrets
                  key: DB_ROOT_PASSWORD
            - name: AWS_ACCESS_KEY_ID
              valueFrom:
                secretKeyRef:
                  name: rechain-dao-secrets
                  key: AWS_ACCESS_KEY_ID
            - name: AWS_SECRET_ACCESS_KEY
              valueFrom:
                secretKeyRef:
                  name: rechain-dao-secrets
                  key: AWS_SECRET_ACCESS_KEY
            volumeMounts:
            - name: backup-storage
              mountPath: /backup
          volumes:
          - name: backup-storage
            persistentVolumeClaim:
              claimName: backup-pvc
          restartPolicy: OnFailure
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: backup-pvc
  namespace: rechain-dao
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: gp2
```

### Application Backup Job
```yaml
# app-backup-job.yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: app-backup
  namespace: rechain-dao
spec:
  schedule: "0 3 * * *"  # Daily at 3 AM
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: app-backup
            image: alpine:latest
            command:
            - /bin/sh
            - -c
            - |
              apk add --no-cache aws-cli
              tar -czf /backup/app-backup-$(date +%Y%m%d_%H%M%S).tar.gz -C /app-storage .
              aws s3 cp /backup/app-backup-$(date +%Y%m%d_%H%M%S).tar.gz s3://rechain-dao-backups/app/
            env:
            - name: AWS_ACCESS_KEY_ID
              valueFrom:
                secretKeyRef:
                  name: rechain-dao-secrets
                  key: AWS_ACCESS_KEY_ID
            - name: AWS_SECRET_ACCESS_KEY
              valueFrom:
                secretKeyRef:
                  name: rechain-dao-secrets
                  key: AWS_SECRET_ACCESS_KEY
            volumeMounts:
            - name: app-storage
              mountPath: /app-storage
            - name: backup-storage
              mountPath: /backup
          volumes:
          - name: app-storage
            persistentVolumeClaim:
              claimName: app-storage-pvc
          - name: backup-storage
            persistentVolumeClaim:
              claimName: backup-pvc
          restartPolicy: OnFailure
```

## Deployment Scripts

### Deploy Script
```bash
#!/bin/bash
# deploy.sh

set -e

# Configuration
NAMESPACE="rechain-dao"
ENVIRONMENT=${1:-production}

echo "Deploying REChain DAO to $ENVIRONMENT environment..."

# Create namespace if it doesn't exist
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Apply RBAC
kubectl apply -f rbac.yaml

# Apply ConfigMaps and Secrets
kubectl apply -f configmap.yaml
kubectl apply -f secrets.yaml

# Apply database
kubectl apply -f mysql-deployment.yaml
kubectl apply -f redis-deployment.yaml

# Wait for database to be ready
echo "Waiting for database to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql -n $NAMESPACE --timeout=300s
kubectl wait --for=condition=ready pod -l app=redis -n $NAMESPACE --timeout=300s

# Apply application
kubectl apply -f app-deployment.yaml
kubectl apply -f hpa.yaml

# Apply services and ingress
kubectl apply -f services.yaml
kubectl apply -f ingress.yaml

# Apply monitoring
kubectl apply -f prometheus.yaml
kubectl apply -f grafana.yaml

# Apply backup jobs
kubectl apply -f backup-job.yaml
kubectl apply -f app-backup-job.yaml

echo "Deployment completed successfully!"

# Show status
kubectl get pods -n $NAMESPACE
kubectl get services -n $NAMESPACE
kubectl get ingress -n $NAMESPACE
```

### Rollback Script
```bash
#!/bin/bash
# rollback.sh

set -e

NAMESPACE="rechain-dao"
REVISION=${1:-previous}

echo "Rolling back to revision $REVISION..."

# Rollback application deployment
kubectl rollout undo deployment/rechain-dao-app -n $NAMESPACE --to-revision=$REVISION

# Wait for rollout to complete
kubectl rollout status deployment/rechain-dao-app -n $NAMESPACE

echo "Rollback completed successfully!"

# Show status
kubectl get pods -n $NAMESPACE
kubectl rollout history deployment/rechain-dao-app -n $NAMESPACE
```

## Conclusion

These Kubernetes manifests provide a comprehensive deployment configuration for the REChain DAO platform, including all necessary components for production deployment, monitoring, and backup. They ensure high availability, scalability, and maintainability of the platform.

Remember: Always test these manifests in a staging environment before deploying to production. Regularly update the manifests to reflect changes in the application and infrastructure requirements.
