# Docker Configurations

## Overview

This document provides comprehensive Docker configurations for the REChain DAO platform, including development, staging, and production environments.

## Table of Contents

1. [Development Environment](#development-environment)
2. [Staging Environment](#staging-environment)
3. [Production Environment](#production-environment)
4. [Database Configurations](#database-configurations)
5. [Monitoring and Logging](#monitoring-and-logging)
6. [Security Configurations](#security-configurations)

## Development Environment

### Docker Compose for Development
```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "8000:8000"
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - DEBUG=true
    depends_on:
      - db
      - redis
    networks:
      - rechain-network

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: rechain_dev
      MYSQL_USER: rechain
      MYSQL_PASSWORD: rechainpassword
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
      - ./docker/mysql/init:/docker-entrypoint-initdb.d
    networks:
      - rechain-network

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - rechain-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./docker/nginx/nginx.dev.conf:/etc/nginx/nginx.conf
    depends_on:
      - app
    networks:
      - rechain-network

volumes:
  db_data:
  redis_data:

networks:
  rechain-network:
    driver: bridge
```

### Development Dockerfile
```dockerfile
# Dockerfile.dev
FROM node:18-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    mysql-client

# Copy package files
COPY package*.json ./
COPY composer.json composer.lock ./

# Install dependencies
RUN npm install
RUN composer install --no-dev --optimize-autoloader

# Copy application code
COPY . .

# Set permissions
RUN chown -R node:node /app
USER node

# Expose port
EXPOSE 8000

# Start application
CMD ["npm", "run", "dev"]
```

## Staging Environment

### Docker Compose for Staging
```yaml
# docker-compose.staging.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.staging
    ports:
      - "8000:8000"
    environment:
      - NODE_ENV=staging
      - DEBUG=false
    depends_on:
      - db
      - redis
    networks:
      - rechain-network
    restart: unless-stopped

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASSWORD}
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
      - ./docker/mysql/init:/docker-entrypoint-initdb.d
    networks:
      - rechain-network
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - rechain-network
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/nginx/nginx.staging.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
    networks:
      - rechain-network
    restart: unless-stopped

volumes:
  db_data:
  redis_data:

networks:
  rechain-network:
    driver: bridge
```

### Staging Dockerfile
```dockerfile
# Dockerfile.staging
FROM node:18-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    mysql-client

# Copy package files
COPY package*.json ./
COPY composer.json composer.lock ./

# Install dependencies
RUN npm ci --only=production
RUN composer install --no-dev --optimize-autoloader

# Copy application code
COPY . .

# Build application
RUN npm run build

# Set permissions
RUN chown -R node:node /app
USER node

# Expose port
EXPOSE 8000

# Start application
CMD ["npm", "start"]
```

## Production Environment

### Docker Compose for Production
```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.prod
    ports:
      - "8000:8000"
    environment:
      - NODE_ENV=production
      - DEBUG=false
    depends_on:
      - db
      - redis
    networks:
      - rechain-network
    restart: always
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'
        reservations:
          memory: 512M
          cpus: '0.25'

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: ${DB_USER}
      MYSQL_PASSWORD: ${DB_PASSWORD}
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
      - ./docker/mysql/init:/docker-entrypoint-initdb.d
    networks:
      - rechain-network
    restart: always
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
        reservations:
          memory: 1G
          cpus: '0.5'

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - rechain-network
    restart: always
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.25'
        reservations:
          memory: 256M
          cpus: '0.1'

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/nginx/nginx.prod.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
    networks:
      - rechain-network
    restart: always
    deploy:
      resources:
        limits:
          memory: 256M
          cpus: '0.25'
        reservations:
          memory: 128M
          cpus: '0.1'

volumes:
  db_data:
  redis_data:

networks:
  rechain-network:
    driver: bridge
```

### Production Dockerfile
```dockerfile
# Dockerfile.prod
FROM node:18-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    mysql-client

# Copy package files
COPY package*.json ./
COPY composer.json composer.lock ./

# Install dependencies
RUN npm ci --only=production
RUN composer install --no-dev --optimize-autoloader

# Copy application code
COPY . .

# Build application
RUN npm run build

# Set permissions
RUN chown -R node:node /app
USER node

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# Start application
CMD ["npm", "start"]
```

## Database Configurations

### MySQL Configuration
```yaml
# docker/mysql/my.cnf
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

### Redis Configuration
```yaml
# docker/redis/redis.conf
# Network
bind 0.0.0.0
port 6379
timeout 0
tcp-keepalive 300

# General
daemonize no
supervised no
pidfile /var/run/redis_6379.pid
loglevel notice
logfile ""
databases 16

# Snapshotting
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /data

# Replication
replica-serve-stale-data yes
replica-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5

# Security
requirepass ${REDIS_PASSWORD}

# Memory management
maxmemory 512mb
maxmemory-policy allkeys-lru
```

## Monitoring and Logging

### Prometheus Configuration
```yaml
# docker/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

rule_files:
  - "rules/*.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'rechain-app'
    static_configs:
      - targets: ['app:8000']
    metrics_path: '/metrics'
    scrape_interval: 5s

  - job_name: 'mysql'
    static_configs:
      - targets: ['db:9104']

  - job_name: 'redis'
    static_configs:
      - targets: ['redis:9121']
```

### Grafana Configuration
```yaml
# docker/grafana/grafana.ini
[server]
http_port = 3000
root_url = http://localhost:3000/

[security]
admin_user = admin
admin_password = ${GRAFANA_PASSWORD}

[database]
type = sqlite3
path = /var/lib/grafana/grafana.db

[log]
mode = console
level = info

[metrics]
enabled = true
```

### ELK Stack Configuration
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
    networks:
      - logging-network

  logstash:
    image: docker.elastic.co/logstash/logstash:8.8.0
    ports:
      - "5044:5044"
    volumes:
      - ./docker/logstash/logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    depends_on:
      - elasticsearch
    networks:
      - logging-network

  kibana:
    image: docker.elastic.co/kibana/kibana:8.8.0
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    depends_on:
      - elasticsearch
    networks:
      - logging-network

volumes:
  elasticsearch_data:

networks:
  logging-network:
    driver: bridge
```

## Security Configurations

### Security Headers
```nginx
# docker/nginx/security.conf
# Security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self' data:; connect-src 'self' https:; frame-ancestors 'self';" always;

# Hide server information
server_tokens off;

# Rate limiting
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;

# SSL configuration
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
ssl_prefer_server_ciphers off;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
```

### Docker Security
```dockerfile
# Security-focused Dockerfile
FROM node:18-alpine

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Install security updates
RUN apk update && apk upgrade

# Copy package files
COPY package*.json ./
COPY composer.json composer.lock ./

# Install dependencies
RUN npm ci --only=production
RUN composer install --no-dev --optimize-autoloader

# Copy application code
COPY . .

# Set proper permissions
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

# Start application
CMD ["npm", "start"]
```

## Environment Variables

### Development Environment
```bash
# .env.dev
NODE_ENV=development
DEBUG=true
PORT=8000

# Database
DB_HOST=db
DB_PORT=3306
DB_NAME=rechain_dev
DB_USER=rechain
DB_PASSWORD=rechainpassword

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=

# JWT
JWT_SECRET=dev-secret-key
JWT_EXPIRES_IN=24h

# Email
SMTP_HOST=localhost
SMTP_PORT=1025
SMTP_USER=
SMTP_PASSWORD=
```

### Production Environment
```bash
# .env.prod
NODE_ENV=production
DEBUG=false
PORT=8000

# Database
DB_HOST=db
DB_PORT=3306
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=${REDIS_PASSWORD}

# JWT
JWT_SECRET=${JWT_SECRET}
JWT_EXPIRES_IN=1h

# Email
SMTP_HOST=${SMTP_HOST}
SMTP_PORT=${SMTP_PORT}
SMTP_USER=${SMTP_USER}
SMTP_PASSWORD=${SMTP_PASSWORD}

# SSL
SSL_CERT_PATH=/etc/nginx/ssl/cert.pem
SSL_KEY_PATH=/etc/nginx/ssl/key.pem
```

## Deployment Scripts

### Deploy Script
```bash
#!/bin/bash
# deploy.sh

set -e

# Configuration
ENVIRONMENT=${1:-staging}
VERSION=${2:-latest}

echo "Deploying REChain DAO to $ENVIRONMENT environment..."

# Build and push images
docker build -t rechain-dao:$VERSION .
docker tag rechain-dao:$VERSION rechain-dao:$ENVIRONMENT

# Deploy to environment
docker-compose -f docker-compose.$ENVIRONMENT.yml down
docker-compose -f docker-compose.$ENVIRONMENT.yml up -d

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 30

# Run health checks
echo "Running health checks..."
curl -f http://localhost:8000/health || exit 1

echo "Deployment completed successfully!"
```

### Backup Script
```bash
#!/bin/bash
# backup.sh

set -e

# Configuration
BACKUP_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)

echo "Starting backup process..."

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup database
echo "Backing up database..."
docker exec rechain-dao_db_1 mysqldump -u root -p$DB_ROOT_PASSWORD --all-databases > $BACKUP_DIR/db_backup_$DATE.sql

# Backup application data
echo "Backing up application data..."
docker exec rechain-dao_app_1 tar -czf /tmp/app_backup_$DATE.tar.gz /app/data
docker cp rechain-dao_app_1:/tmp/app_backup_$DATE.tar.gz $BACKUP_DIR/

# Cleanup old backups (keep last 7 days)
echo "Cleaning up old backups..."
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed successfully!"
```

## Conclusion

These Docker configurations provide a comprehensive setup for the REChain DAO platform across different environments. They include security best practices, monitoring, logging, and deployment automation.

Remember: Always review and customize these configurations based on your specific requirements and security policies before deploying to production.
