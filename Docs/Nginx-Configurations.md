# Nginx Configurations

## Overview

This document provides comprehensive Nginx configurations for the REChain DAO platform, including load balancing, SSL termination, security headers, and performance optimizations.

## Table of Contents

1. [Main Configuration](#main-configuration)
2. [Load Balancing](#load-balancing)
3. [SSL Configuration](#ssl-configuration)
4. [Security Headers](#security-headers)
5. [Performance Optimization](#performance-optimization)
6. [Rate Limiting](#rate-limiting)
7. [Monitoring and Logging](#monitoring-and-logging)

## Main Configuration

### nginx.conf
```nginx
# nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    # Logging
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for" '
                    'rt=$request_time uct="$upstream_connect_time" '
                    'uht="$upstream_header_time" urt="$upstream_response_time"';
    
    access_log /var/log/nginx/access.log main;
    
    # Basic Settings
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;
    
    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;
    
    # Rate Limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;
    limit_req_zone $binary_remote_addr zone=general:10m rate=1r/s;
    
    # Connection Limiting
    limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;
    limit_conn_zone $server_name zone=conn_limit_per_server:10m;
    
    # Upstream Servers
    upstream rechain_dao_backend {
        least_conn;
        server 10.0.1.10:8000 max_fails=3 fail_timeout=30s;
        server 10.0.1.11:8000 max_fails=3 fail_timeout=30s;
        server 10.0.1.12:8000 max_fails=3 fail_timeout=30s;
        keepalive 32;
    }
    
    upstream rechain_dao_websocket {
        ip_hash;
        server 10.0.1.10:8001;
        server 10.0.1.11:8001;
        server 10.0.1.12:8001;
    }
    
    # Include additional configurations
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

## Load Balancing

### Load Balancer Configuration
```nginx
# conf.d/load-balancer.conf
upstream rechain_dao_api {
    least_conn;
    server api-1.rechain-dao.internal:8000 weight=3 max_fails=3 fail_timeout=30s;
    server api-2.rechain-dao.internal:8000 weight=3 max_fails=3 fail_timeout=30s;
    server api-3.rechain-dao.internal:8000 weight=2 max_fails=3 fail_timeout=30s;
    server api-4.rechain-dao.internal:8000 weight=2 max_fails=3 fail_timeout=30s;
    
    # Health checks
    keepalive 32;
    keepalive_requests 100;
    keepalive_timeout 60s;
}

upstream rechain_dao_web {
    least_conn;
    server web-1.rechain-dao.internal:3000 weight=2 max_fails=3 fail_timeout=30s;
    server web-2.rechain-dao.internal:3000 weight=2 max_fails=3 fail_timeout=30s;
    server web-3.rechain-dao.internal:3000 weight=1 max_fails=3 fail_timeout=30s;
    
    keepalive 16;
    keepalive_requests 50;
    keepalive_timeout 30s;
}

upstream rechain_dao_websocket {
    ip_hash;
    server ws-1.rechain-dao.internal:8001;
    server ws-2.rechain-dao.internal:8001;
    server ws-3.rechain-dao.internal:8001;
}

# Health check endpoint
server {
    listen 80;
    server_name health.rechain-dao.com;
    
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
    
    location /nginx_status {
        stub_status on;
        access_log off;
        allow 10.0.0.0/8;
        allow 172.16.0.0/12;
        allow 192.168.0.0/16;
        deny all;
    }
}
```

## SSL Configuration

### SSL Termination
```nginx
# conf.d/ssl.conf
# SSL Configuration
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
ssl_prefer_server_ciphers off;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
ssl_session_tickets off;

# OCSP Stapling
ssl_stapling on;
ssl_stapling_verify on;
ssl_trusted_certificate /etc/nginx/ssl/ca-bundle.pem;
resolver 8.8.8.8 8.8.4.4 valid=300s;
resolver_timeout 5s;

# HSTS
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

# SSL Certificate Configuration
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name api.rechain-dao.com;
    
    ssl_certificate /etc/nginx/ssl/api.rechain-dao.com.crt;
    ssl_certificate_key /etc/nginx/ssl/api.rechain-dao.com.key;
    
    # Include security headers
    include /etc/nginx/conf.d/security-headers.conf;
    
    # API routes
    location /api/ {
        limit_req zone=api burst=20 nodelay;
        limit_conn conn_limit_per_ip 10;
        
        proxy_pass http://rechain_dao_api;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
        
        # Buffering
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
        proxy_busy_buffers_size 8k;
    }
    
    # WebSocket support
    location /ws/ {
        proxy_pass http://rechain_dao_websocket;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket timeouts
        proxy_read_timeout 86400;
        proxy_send_timeout 86400;
    }
}

# HTTP to HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name api.rechain-dao.com;
    return 301 https://$server_name$request_uri;
}
```

## Security Headers

### Security Headers Configuration
```nginx
# conf.d/security-headers.conf
# Security Headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;

# Content Security Policy
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://cdn.jsdelivr.net https://unpkg.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:; connect-src 'self' https: wss:; frame-ancestors 'self'; base-uri 'self'; form-action 'self';" always;

# Remove server information
server_tokens off;

# Hide Nginx version
more_clear_headers 'Server';

# Security headers for API endpoints
location /api/ {
    add_header X-API-Version "1.0" always;
    add_header X-Request-ID $request_id always;
    
    # CORS headers
    add_header Access-Control-Allow-Origin "https://rechain-dao.com" always;
    add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS" always;
    add_header Access-Control-Allow-Headers "Authorization, Content-Type, X-Requested-With" always;
    add_header Access-Control-Allow-Credentials "true" always;
    
    # Handle preflight requests
    if ($request_method = 'OPTIONS') {
        add_header Access-Control-Allow-Origin "https://rechain-dao.com";
        add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS";
        add_header Access-Control-Allow-Headers "Authorization, Content-Type, X-Requested-With";
        add_header Access-Control-Allow-Credentials "true";
        add_header Access-Control-Max-Age 86400;
        add_header Content-Length 0;
        add_header Content-Type text/plain;
        return 204;
    }
}
```

## Performance Optimization

### Performance Configuration
```nginx
# conf.d/performance.conf
# Gzip Compression
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_proxied any;
gzip_comp_level 6;
gzip_types
    text/plain
    text/css
    text/xml
    text/javascript
    application/json
    application/javascript
    application/xml+rss
    application/atom+xml
    image/svg+xml
    application/font-woff
    application/font-woff2;

# Brotli Compression (if available)
# brotli on;
# brotli_comp_level 6;
# brotli_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

# Caching
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=api_cache:10m max_size=1g inactive=60m use_temp_path=off;

# Cache configuration
map $request_method $purge_method {
    PURGE 1;
    default 0;
}

# Static file caching
location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|eot|svg)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
    add_header Vary Accept-Encoding;
    
    # CORS for fonts
    if ($request_filename ~* \.(woff|woff2|ttf|eot)$) {
        add_header Access-Control-Allow-Origin "*";
    }
}

# API caching
location /api/ {
    proxy_cache api_cache;
    proxy_cache_valid 200 302 10m;
    proxy_cache_valid 404 1m;
    proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
    proxy_cache_lock on;
    proxy_cache_key "$scheme$request_method$host$request_uri";
    
    # Cache bypass
    proxy_cache_bypass $purge_method;
    proxy_no_cache $purge_method;
    
    # Add cache status header
    add_header X-Cache-Status $upstream_cache_status;
}

# Connection optimization
upstream rechain_dao_backend {
    least_conn;
    server 10.0.1.10:8000 max_fails=3 fail_timeout=30s;
    server 10.0.1.11:8000 max_fails=3 fail_timeout=30s;
    server 10.0.1.12:8000 max_fails=3 fail_timeout=30s;
    
    # Connection pooling
    keepalive 32;
    keepalive_requests 100;
    keepalive_timeout 60s;
}

# Proxy optimizations
proxy_http_version 1.1;
proxy_set_header Connection "";
proxy_buffering on;
proxy_buffer_size 4k;
proxy_buffers 8 4k;
proxy_busy_buffers_size 8k;
proxy_temp_file_write_size 8k;
```

## Rate Limiting

### Rate Limiting Configuration
```nginx
# conf.d/rate-limiting.conf
# Rate limiting zones
limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;
limit_req_zone $binary_remote_addr zone=general:10m rate=1r/s;
limit_req_zone $binary_remote_addr zone=strict:10m rate=1r/s;

# Connection limiting
limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;
limit_conn_zone $server_name zone=conn_limit_per_server:10m;

# API rate limiting
location /api/ {
    limit_req zone=api burst=20 nodelay;
    limit_conn conn_limit_per_ip 10;
    
    # Different limits for different endpoints
    location ~* /api/auth/ {
        limit_req zone=login burst=5 nodelay;
    }
    
    location ~* /api/admin/ {
        limit_req zone=strict burst=2 nodelay;
    }
    
    proxy_pass http://rechain_dao_backend;
    # ... other proxy settings
}

# General rate limiting
location / {
    limit_req zone=general burst=10 nodelay;
    limit_conn conn_limit_per_ip 20;
    
    proxy_pass http://rechain_dao_backend;
    # ... other proxy settings
}

# Rate limiting for specific IPs
geo $limited {
    default 0;
    10.0.0.0/8 1;
    172.16.0.0/12 1;
    192.168.0.0/16 1;
}

map $limited $limit_key {
    0 $binary_remote_addr;
    1 "";
}

limit_req_zone $limit_key zone=api:10m rate=10r/s;
```

## Monitoring and Logging

### Logging Configuration
```nginx
# conf.d/logging.conf
# Custom log formats
log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for" '
                'rt=$request_time uct="$upstream_connect_time" '
                'uht="$upstream_header_time" urt="$upstream_response_time"';

log_format json escape=json '{'
    '"time":"$time_iso8601",'
    '"remote_addr":"$remote_addr",'
    '"remote_user":"$remote_user",'
    '"request":"$request",'
    '"status":$status,'
    '"body_bytes_sent":$body_bytes_sent,'
    '"http_referer":"$http_referer",'
    '"http_user_agent":"$http_user_agent",'
    '"http_x_forwarded_for":"$http_x_forwarded_for",'
    '"request_time":$request_time,'
    '"upstream_connect_time":"$upstream_connect_time",'
    '"upstream_header_time":"$upstream_header_time",'
    '"upstream_response_time":"$upstream_response_time",'
    '"upstream_cache_status":"$upstream_cache_status"'
'}';

# Access logging
access_log /var/log/nginx/access.log main;
access_log /var/log/nginx/access.json json;

# Error logging
error_log /var/log/nginx/error.log warn;

# Log rotation
log_format rotation '$remote_addr - $remote_user [$time_local] "$request" '
                   '$status $body_bytes_sent "$http_referer" '
                   '"$http_user_agent" "$http_x_forwarded_for"';

# Conditional logging
map $status $loggable {
    ~^[23] 0;
    default 1;
}

access_log /var/log/nginx/access.log main if=$loggable;

# Logging for specific locations
location /api/ {
    access_log /var/log/nginx/api.log main;
    error_log /var/log/nginx/api.error.log;
    
    # ... other configuration
}

# Health check logging
location /health {
    access_log off;
    return 200 "healthy\n";
    add_header Content-Type text/plain;
}

# Status page
location /nginx_status {
    stub_status on;
    access_log off;
    allow 10.0.0.0/8;
    allow 172.16.0.0/12;
    allow 192.168.0.0/16;
    deny all;
}
```

### Monitoring Configuration
```nginx
# conf.d/monitoring.conf
# Prometheus metrics endpoint
location /metrics {
    access_log off;
    allow 10.0.0.0/8;
    allow 172.16.0.0/12;
    allow 192.168.0.0/16;
    deny all;
    
    # Basic metrics
    return 200 "nginx_up 1\nnginx_connections_active $connections_active\nnginx_connections_reading $connections_reading\nnginx_connections_writing $connections_writing\nnginx_connections_waiting $connections_waiting\n";
    add_header Content-Type text/plain;
}

# Health check for load balancer
location /health {
    access_log off;
    
    # Check upstream health
    proxy_pass http://rechain_dao_backend/health;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    # Timeout for health check
    proxy_connect_timeout 5s;
    proxy_send_timeout 5s;
    proxy_read_timeout 5s;
}

# Detailed status page
location /status {
    stub_status on;
    access_log off;
    
    # Allow only from monitoring systems
    allow 10.0.0.0/8;
    allow 172.16.0.0/12;
    allow 192.168.0.0/16;
    deny all;
    
    # Add custom headers
    add_header Content-Type text/plain;
    add_header X-Nginx-Version $nginx_version;
    add_header X-Server-Name $hostname;
}
```

## Site-Specific Configurations

### Main Site Configuration
```nginx
# sites-available/rechain-dao.com
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name rechain-dao.com www.rechain-dao.com;
    
    # SSL configuration
    ssl_certificate /etc/nginx/ssl/rechain-dao.com.crt;
    ssl_certificate_key /etc/nginx/ssl/rechain-dao.com.key;
    
    # Security headers
    include /etc/nginx/conf.d/security-headers.conf;
    
    # Root directory
    root /var/www/rechain-dao;
    index index.html index.htm;
    
    # Main location
    location / {
        try_files $uri $uri/ /index.html;
        
        # Caching for static files
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
    
    # API proxy
    location /api/ {
        limit_req zone=api burst=20 nodelay;
        limit_conn conn_limit_per_ip 10;
        
        proxy_pass http://rechain_dao_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }
    
    # WebSocket support
    location /ws/ {
        proxy_pass http://rechain_dao_websocket;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket timeouts
        proxy_read_timeout 86400;
        proxy_send_timeout 86400;
    }
    
    # Error pages
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    
    location = /50x.html {
        root /var/www/rechain-dao;
    }
}

# HTTP to HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name rechain-dao.com www.rechain-dao.com;
    return 301 https://$server_name$request_uri;
}
```

### API Site Configuration
```nginx
# sites-available/api.rechain-dao.com
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name api.rechain-dao.com;
    
    # SSL configuration
    ssl_certificate /etc/nginx/ssl/api.rechain-dao.com.crt;
    ssl_certificate_key /etc/nginx/ssl/api.rechain-dao.com.key;
    
    # Security headers
    include /etc/nginx/conf.d/security-headers.conf;
    
    # API routes
    location / {
        limit_req zone=api burst=20 nodelay;
        limit_conn conn_limit_per_ip 10;
        
        proxy_pass http://rechain_dao_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
        
        # Buffering
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
        proxy_busy_buffers_size 8k;
    }
    
    # Health check
    location /health {
        access_log off;
        proxy_pass http://rechain_dao_backend/health;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    # Metrics
    location /metrics {
        access_log off;
        allow 10.0.0.0/8;
        allow 172.16.0.0/12;
        allow 192.168.0.0/16;
        deny all;
        
        proxy_pass http://rechain_dao_backend/metrics;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# HTTP to HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name api.rechain-dao.com;
    return 301 https://$server_name$request_uri;
}
```

## Deployment Scripts

### Deploy Script
```bash
#!/bin/bash
# deploy-nginx.sh

set -e

# Configuration
NGINX_CONFIG_DIR="/etc/nginx"
SITES_AVAILABLE="$NGINX_CONFIG_DIR/sites-available"
SITES_ENABLED="$NGINX_CONFIG_DIR/sites-enabled"
SSL_DIR="/etc/nginx/ssl"
BACKUP_DIR="/etc/nginx/backup"

echo "Deploying Nginx configuration for REChain DAO..."

# Create backup
echo "Creating backup..."
mkdir -p $BACKUP_DIR
cp -r $NGINX_CONFIG_DIR $BACKUP_DIR/nginx-$(date +%Y%m%d_%H%M%S)

# Test configuration
echo "Testing Nginx configuration..."
nginx -t

if [ $? -eq 0 ]; then
    echo "Configuration test passed. Reloading Nginx..."
    systemctl reload nginx
    echo "Nginx configuration deployed successfully!"
else
    echo "Configuration test failed. Rolling back..."
    # Rollback logic here
    exit 1
fi

# Check status
echo "Checking Nginx status..."
systemctl status nginx --no-pager

echo "Deployment completed successfully!"
```

### SSL Setup Script
```bash
#!/bin/bash
# setup-ssl.sh

set -e

# Configuration
DOMAIN=$1
EMAIL=$2
SSL_DIR="/etc/nginx/ssl"
CERTBOT_DIR="/etc/letsencrypt/live"

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo "Usage: $0 <domain> <email>"
    exit 1
fi

echo "Setting up SSL certificate for $DOMAIN..."

# Install certbot if not installed
if ! command -v certbot &> /dev/null; then
    echo "Installing certbot..."
    apt-get update
    apt-get install -y certbot python3-certbot-nginx
fi

# Obtain certificate
echo "Obtaining SSL certificate..."
certbot --nginx -d $DOMAIN --email $EMAIL --agree-tos --non-interactive

# Create symlinks for Nginx
echo "Creating SSL symlinks..."
ln -sf $CERTBOT_DIR/$DOMAIN/fullchain.pem $SSL_DIR/$DOMAIN.crt
ln -sf $CERTBOT_DIR/$DOMAIN/privkey.pem $SSL_DIR/$DOMAIN.key

# Set up auto-renewal
echo "Setting up auto-renewal..."
(crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -

echo "SSL certificate setup completed successfully!"
```

## Conclusion

These Nginx configurations provide a comprehensive setup for the REChain DAO platform, including load balancing, SSL termination, security headers, performance optimization, rate limiting, and monitoring. They ensure high availability, security, and performance of the platform.

Remember: Always test Nginx configurations before deploying to production. Regularly update SSL certificates and monitor performance metrics to ensure optimal operation.
