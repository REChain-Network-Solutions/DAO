# Deployment Guide

## Overview

This guide provides comprehensive instructions for deploying the REChain DAO Platform across different environments and infrastructure setups.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Docker Deployment](#docker-deployment)
4. [Kubernetes Deployment](#kubernetes-deployment)
5. [Cloud Deployment](#cloud-deployment)
6. [Monitoring Setup](#monitoring-setup)
7. [Troubleshooting](#troubleshooting)

## Prerequisites

### System Requirements

#### Minimum Requirements
- **CPU**: 2 cores
- **RAM**: 4GB
- **Storage**: 20GB SSD
- **OS**: Ubuntu 20.04+ / CentOS 8+ / RHEL 8+

#### Recommended Requirements
- **CPU**: 4+ cores
- **RAM**: 8GB+
- **Storage**: 50GB+ SSD
- **OS**: Ubuntu 22.04 LTS

### Software Dependencies

#### Required
- **Node.js**: 18.0.0+
- **MySQL**: 8.0+
- **Redis**: 6.0+
- **Docker**: 20.10+
- **Docker Compose**: 2.0+

#### Optional
- **Kubernetes**: 1.24+
- **Helm**: 3.8+
- **Terraform**: 1.0+
- **Ansible**: 2.9+

## Environment Setup

### 1. Clone Repository

```bash
git clone https://github.com/your-username/rechain-dao.git
cd rechain-dao
```

### 2. Install Dependencies

```bash
# Install Node.js dependencies
npm install

# Install system dependencies (Ubuntu/Debian)
sudo apt update
sudo apt install -y mysql-server redis-server nginx

# Install system dependencies (CentOS/RHEL)
sudo yum update
sudo yum install -y mysql-server redis nginx
```

### 3. Configure Environment

```bash
# Copy environment template
cp env.example .env

# Edit environment variables
nano .env
```

#### Required Environment Variables

```bash
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_NAME=rechain_dao
DB_USER=rechain_user
DB_PASSWORD=your_secure_password

# Redis Configuration
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key
JWT_EXPIRES_IN=1h

# Ethereum Configuration
ETHEREUM_RPC_URL=https://mainnet.infura.io/v3/your_project_id
ETHEREUM_NETWORK=mainnet
```

### 4. Database Setup

```bash
# Start MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql

# Create database and user
mysql -u root -p
```

```sql
CREATE DATABASE rechain_dao;
CREATE USER 'rechain_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON rechain_dao.* TO 'rechain_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
# Run database migrations
npm run db:migrate

# Seed database with initial data
npm run db:seed
```

### 5. Redis Setup

```bash
# Start Redis service
sudo systemctl start redis
sudo systemctl enable redis

# Configure Redis (optional)
sudo nano /etc/redis/redis.conf
```

## Docker Deployment

### 1. Development Environment

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Stop environment
docker-compose -f docker-compose.dev.yml down
```

### 2. Production Environment

```bash
# Build production image
docker build -t rechain-dao:latest .

# Start production environment
docker-compose up -d

# View logs
docker-compose logs -f

# Stop environment
docker-compose down
```

### 3. Custom Configuration

```yaml
# docker-compose.override.yml
version: '3.8'

services:
  app:
    environment:
      - NODE_ENV=production
      - DB_HOST=mysql
      - REDIS_HOST=redis
    volumes:
      - ./uploads:/app/uploads
      - ./logs:/app/logs

  mysql:
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASSWORD}

  redis:
    command: redis-server --requirepass ${REDIS_PASSWORD}
```

## Kubernetes Deployment

### 1. Prerequisites

```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

### 2. Deploy with kubectl

```bash
# Create namespace
kubectl apply -f k8s/namespace.yaml

# Deploy application
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

# Check deployment status
kubectl get pods -n rechain-dao
kubectl get services -n rechain-dao
```

### 3. Deploy with Helm

```bash
# Add Helm repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Deploy application
helm install rechain-dao ./helm/rechain-dao \
  --namespace rechain-dao \
  --create-namespace \
  --set image.tag=latest \
  --set mysql.enabled=true \
  --set redis.enabled=true

# Check deployment status
helm status rechain-dao -n rechain-dao
```

### 4. Configure Ingress

```yaml
# k8s/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rechain-dao-ingress
  namespace: rechain-dao
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - api.rechain-dao.com
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
```

```bash
# Apply Ingress
kubectl apply -f k8s/ingress.yaml
```

## Cloud Deployment

### 1. AWS Deployment

#### Using EKS

```bash
# Create EKS cluster
eksctl create cluster --name rechain-dao --region us-west-2 --nodegroup-name workers --node-type t3.medium --nodes 3

# Deploy application
kubectl apply -f k8s/

# Configure load balancer
kubectl apply -f k8s/ingress.yaml
```

#### Using ECS

```bash
# Build and push image
docker build -t rechain-dao .
docker tag rechain-dao:latest 123456789012.dkr.ecr.us-west-2.amazonaws.com/rechain-dao:latest
docker push 123456789012.dkr.ecr.us-west-2.amazonaws.com/rechain-dao:latest

# Deploy with ECS
aws ecs create-service --cluster rechain-dao --service-name rechain-dao-app --task-definition rechain-dao:1 --desired-count 3
```

### 2. Google Cloud Deployment

#### Using GKE

```bash
# Create GKE cluster
gcloud container clusters create rechain-dao --zone us-central1-a --num-nodes 3

# Deploy application
kubectl apply -f k8s/

# Configure load balancer
kubectl apply -f k8s/ingress.yaml
```

### 3. Azure Deployment

#### Using AKS

```bash
# Create AKS cluster
az aks create --resource-group rechain-dao --name rechain-dao --node-count 3 --enable-addons monitoring

# Deploy application
kubectl apply -f k8s/

# Configure load balancer
kubectl apply -f k8s/ingress.yaml
```

## Monitoring Setup

### 1. Prometheus Configuration

```yaml
# monitoring/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'rechain-dao'
    static_configs:
      - targets: ['localhost:3000']
    metrics_path: /metrics
    scrape_interval: 5s
```

### 2. Grafana Dashboard

```bash
# Install Grafana
helm install grafana grafana/grafana

# Get admin password
kubectl get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode

# Access Grafana
kubectl port-forward svc/grafana 3000:80
```

### 3. Log Aggregation

```yaml
# monitoring/fluentd.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
data:
  fluent.conf: |
    <source>
      @type tail
      path /var/log/containers/*rechain-dao*.log
      pos_file /var/log/fluentd-containers.log.pos
      tag kubernetes.*
      format json
    </source>
    
    <match kubernetes.**>
      @type elasticsearch
      host elasticsearch.logging.svc.cluster.local
      port 9200
      index_name rechain-dao
    </match>
```

## Troubleshooting

### Common Issues

#### 1. Database Connection Failed

```bash
# Check MySQL status
sudo systemctl status mysql

# Check MySQL logs
sudo journalctl -u mysql

# Test connection
mysql -u rechain_user -p rechain_dao
```

#### 2. Redis Connection Failed

```bash
# Check Redis status
sudo systemctl status redis

# Check Redis logs
sudo journalctl -u redis

# Test connection
redis-cli ping
```

#### 3. Application Won't Start

```bash
# Check application logs
docker-compose logs app

# Check environment variables
docker-compose exec app env

# Test database connection
docker-compose exec app npm run db:migrate
```

#### 4. Kubernetes Pod Issues

```bash
# Check pod status
kubectl get pods -n rechain-dao

# Check pod logs
kubectl logs -f deployment/rechain-dao-app -n rechain-dao

# Check pod events
kubectl describe pod <pod-name> -n rechain-dao
```

### Performance Issues

#### 1. High Memory Usage

```bash
# Check memory usage
docker stats
kubectl top pods -n rechain-dao

# Optimize Node.js memory
export NODE_OPTIONS="--max-old-space-size=4096"
```

#### 2. Slow Database Queries

```bash
# Check slow query log
mysql -u root -p -e "SHOW VARIABLES LIKE 'slow_query_log';"

# Analyze query performance
mysql -u root -p -e "SHOW PROCESSLIST;"
```

#### 3. High CPU Usage

```bash
# Check CPU usage
top
htop

# Check application metrics
curl http://localhost:3000/metrics
```

### Security Issues

#### 1. SSL Certificate Issues

```bash
# Check certificate status
openssl s_client -connect api.rechain-dao.com:443 -servername api.rechain-dao.com

# Renew Let's Encrypt certificate
certbot renew --dry-run
```

#### 2. Authentication Issues

```bash
# Check JWT configuration
grep JWT_SECRET .env

# Test authentication
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'
```

## Maintenance

### 1. Regular Updates

```bash
# Update dependencies
npm update

# Update Docker images
docker-compose pull
docker-compose up -d

# Update Kubernetes deployment
kubectl set image deployment/rechain-dao-app rechain-dao-app=rechain-dao:latest
```

### 2. Backup Procedures

```bash
# Database backup
mysqldump -u root -p rechain_dao > backup_$(date +%Y%m%d).sql

# File backup
tar -czf files_backup_$(date +%Y%m%d).tar.gz uploads/ logs/

# Kubernetes backup
kubectl get all -n rechain-dao -o yaml > k8s_backup_$(date +%Y%m%d).yaml
```

### 3. Monitoring Alerts

```yaml
# monitoring/alerts.yml
groups:
- name: rechain-dao
  rules:
  - alert: HighErrorRate
    expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: "High error rate detected"
      
  - alert: DatabaseDown
    expr: mysql_up == 0
    for: 1m
    labels:
      severity: critical
    annotations:
      summary: "Database is down"
```

## Conclusion

This deployment guide provides comprehensive instructions for deploying the REChain DAO Platform across various environments. Choose the deployment method that best fits your infrastructure and requirements.

For additional support, please refer to our [documentation](docs/) or contact our [support team](mailto:support@rechain-dao.com).