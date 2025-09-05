# Environment Templates

## Overview

This document provides comprehensive environment templates for the REChain DAO platform, including development, staging, and production configurations with proper security and monitoring setups.

## Table of Contents

1. [Development Environment](#development-environment)
2. [Staging Environment](#staging-environment)
3. [Production Environment](#production-environment)
4. [Environment Variables](#environment-variables)
5. [Configuration Management](#configuration-management)

## Development Environment

### Development Configuration
```yaml
# config/development.yml
app:
  name: "REChain DAO"
  version: "1.0.0"
  environment: "development"
  debug: true
  log_level: "debug"

server:
  host: "0.0.0.0"
  port: 8000
  ssl: false

database:
  host: "localhost"
  port: 3306
  name: "rechain_dev"
  user: "rechain"
  password: "dev_password"
  charset: "utf8mb4"
  collation: "utf8mb4_unicode_ci"

redis:
  host: "localhost"
  port: 6379
  password: ""
  database: 0

cache:
  driver: "redis"
  prefix: "rechain_dev"
  ttl: 3600

mail:
  driver: "log"
  host: "localhost"
  port: 1025
  username: ""
  password: ""
  encryption: null

storage:
  driver: "local"
  root: "storage/app"
  url: "http://localhost:8000/storage"

blockchain:
  network: "testnet"
  rpc_url: "https://rpc.testnet.example.com"
  private_key: "test_private_key"
  gas_limit: 21000
  gas_price: "20000000000"

monitoring:
  enabled: false
  metrics_port: 9090
  health_check_interval: 30
```

### Development Docker Compose
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
      - dev-network

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: rechain_dev
      MYSQL_USER: rechain
      MYSQL_PASSWORD: dev_password
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - dev-network

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - dev-network

volumes:
  db_data:
  redis_data:

networks:
  dev-network:
    driver: bridge
```

## Staging Environment

### Staging Configuration
```yaml
# config/staging.yml
app:
  name: "REChain DAO"
  version: "1.0.0"
  environment: "staging"
  debug: false
  log_level: "info"

server:
  host: "0.0.0.0"
  port: 8000
  ssl: true
  ssl_cert: "/etc/ssl/certs/rechain-staging.crt"
  ssl_key: "/etc/ssl/private/rechain-staging.key"

database:
  host: "${DB_HOST}"
  port: 3306
  name: "${DB_NAME}"
  user: "${DB_USER}"
  password: "${DB_PASSWORD}"
  charset: "utf8mb4"
  collation: "utf8mb4_unicode_ci"

redis:
  host: "${REDIS_HOST}"
  port: 6379
  password: "${REDIS_PASSWORD}"
  database: 0

cache:
  driver: "redis"
  prefix: "rechain_staging"
  ttl: 1800

mail:
  driver: "smtp"
  host: "${SMTP_HOST}"
  port: 587
  username: "${SMTP_USERNAME}"
  password: "${SMTP_PASSWORD}"
  encryption: "tls"

storage:
  driver: "s3"
  bucket: "rechain-staging"
  region: "us-east-1"
  access_key: "${AWS_ACCESS_KEY_ID}"
  secret_key: "${AWS_SECRET_ACCESS_KEY}"

blockchain:
  network: "testnet"
  rpc_url: "${BLOCKCHAIN_RPC_URL}"
  private_key: "${BLOCKCHAIN_PRIVATE_KEY}"
  gas_limit: 21000
  gas_price: "20000000000"

monitoring:
  enabled: true
  metrics_port: 9090
  health_check_interval: 30
  prometheus_url: "http://prometheus:9090"
  grafana_url: "http://grafana:3000"
```

### Staging Docker Compose
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
      - staging-network
    restart: unless-stopped

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: "${DB_ROOT_PASSWORD}"
      MYSQL_DATABASE: "${DB_NAME}"
      MYSQL_USER: "${DB_USER}"
      MYSQL_PASSWORD: "${DB_PASSWORD}"
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - staging-network
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - staging-network
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.staging.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
    networks:
      - staging-network
    restart: unless-stopped

volumes:
  db_data:
  redis_data:

networks:
  staging-network:
    driver: bridge
```

## Production Environment

### Production Configuration
```yaml
# config/production.yml
app:
  name: "REChain DAO"
  version: "1.0.0"
  environment: "production"
  debug: false
  log_level: "warning"

server:
  host: "0.0.0.0"
  port: 8000
  ssl: true
  ssl_cert: "/etc/ssl/certs/rechain-production.crt"
  ssl_key: "/etc/ssl/private/rechain-production.key"

database:
  host: "${DB_HOST}"
  port: 3306
  name: "${DB_NAME}"
  user: "${DB_USER}"
  password: "${DB_PASSWORD}"
  charset: "utf8mb4"
  collation: "utf8mb4_unicode_ci"
  ssl: true
  ssl_ca: "/etc/ssl/certs/ca-cert.pem"

redis:
  host: "${REDIS_HOST}"
  port: 6379
  password: "${REDIS_PASSWORD}"
  database: 0
  ssl: true

cache:
  driver: "redis"
  prefix: "rechain_prod"
  ttl: 3600

mail:
  driver: "smtp"
  host: "${SMTP_HOST}"
  port: 587
  username: "${SMTP_USERNAME}"
  password: "${SMTP_PASSWORD}"
  encryption: "tls"

storage:
  driver: "s3"
  bucket: "rechain-production"
  region: "us-east-1"
  access_key: "${AWS_ACCESS_KEY_ID}"
  secret_key: "${AWS_SECRET_ACCESS_KEY}"

blockchain:
  network: "mainnet"
  rpc_url: "${BLOCKCHAIN_RPC_URL}"
  private_key: "${BLOCKCHAIN_PRIVATE_KEY}"
  gas_limit: 21000
  gas_price: "20000000000"

monitoring:
  enabled: true
  metrics_port: 9090
  health_check_interval: 30
  prometheus_url: "http://prometheus:9090"
  grafana_url: "http://grafana:3000"
  alertmanager_url: "http://alertmanager:9093"

security:
  rate_limiting:
    enabled: true
    requests_per_minute: 100
    burst_size: 200
  
  cors:
    enabled: true
    allowed_origins: ["https://rechain-dao.com"]
    allowed_methods: ["GET", "POST", "PUT", "DELETE"]
    allowed_headers: ["Content-Type", "Authorization"]
  
  headers:
    x_frame_options: "SAMEORIGIN"
    x_content_type_options: "nosniff"
    x_xss_protection: "1; mode=block"
    strict_transport_security: "max-age=31536000; includeSubDomains"
```

### Production Docker Compose
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
      - prod-network
    restart: always
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
        reservations:
          memory: 1G
          cpus: '0.5'

  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: "${DB_ROOT_PASSWORD}"
      MYSQL_DATABASE: "${DB_NAME}"
      MYSQL_USER: "${DB_USER}"
      MYSQL_PASSWORD: "${DB_PASSWORD}"
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - prod-network
    restart: always
    deploy:
      resources:
        limits:
          memory: 4G
          cpus: '2.0'
        reservations:
          memory: 2G
          cpus: '1.0'

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - prod-network
    restart: always
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '0.5'
        reservations:
          memory: 512M
          cpus: '0.25'

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.prod.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
    networks:
      - prod-network
    restart: always
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
        reservations:
          memory: 256M
          cpus: '0.25'

volumes:
  db_data:
  redis_data:

networks:
  prod-network:
    driver: bridge
```

## Environment Variables

### Development Environment Variables
```bash
# .env.development
NODE_ENV=development
DEBUG=true
PORT=8000

# Database
DB_HOST=localhost
DB_PORT=3306
DB_NAME=rechain_dev
DB_USER=rechain
DB_PASSWORD=dev_password

# Redis
REDIS_HOST=localhost
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

# Blockchain
BLOCKCHAIN_NETWORK=testnet
BLOCKCHAIN_RPC_URL=https://rpc.testnet.example.com
BLOCKCHAIN_PRIVATE_KEY=test_private_key

# Monitoring
MONITORING_ENABLED=false
METRICS_PORT=9090
```

### Staging Environment Variables
```bash
# .env.staging
NODE_ENV=staging
DEBUG=false
PORT=8000

# Database
DB_HOST=${DB_HOST}
DB_PORT=3306
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}

# Redis
REDIS_HOST=${REDIS_HOST}
REDIS_PORT=6379
REDIS_PASSWORD=${REDIS_PASSWORD}

# JWT
JWT_SECRET=${JWT_SECRET}
JWT_EXPIRES_IN=1h

# Email
SMTP_HOST=${SMTP_HOST}
SMTP_PORT=587
SMTP_USER=${SMTP_USER}
SMTP_PASSWORD=${SMTP_PASSWORD}

# Blockchain
BLOCKCHAIN_NETWORK=testnet
BLOCKCHAIN_RPC_URL=${BLOCKCHAIN_RPC_URL}
BLOCKCHAIN_PRIVATE_KEY=${BLOCKCHAIN_PRIVATE_KEY}

# Monitoring
MONITORING_ENABLED=true
METRICS_PORT=9090
PROMETHEUS_URL=http://prometheus:9090
GRAFANA_URL=http://grafana:3000
```

### Production Environment Variables
```bash
# .env.production
NODE_ENV=production
DEBUG=false
PORT=8000

# Database
DB_HOST=${DB_HOST}
DB_PORT=3306
DB_NAME=${DB_NAME}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}

# Redis
REDIS_HOST=${REDIS_HOST}
REDIS_PORT=6379
REDIS_PASSWORD=${REDIS_PASSWORD}

# JWT
JWT_SECRET=${JWT_SECRET}
JWT_EXPIRES_IN=1h

# Email
SMTP_HOST=${SMTP_HOST}
SMTP_PORT=587
SMTP_USER=${SMTP_USER}
SMTP_PASSWORD=${SMTP_PASSWORD}

# Blockchain
BLOCKCHAIN_NETWORK=mainnet
BLOCKCHAIN_RPC_URL=${BLOCKCHAIN_RPC_URL}
BLOCKCHAIN_PRIVATE_KEY=${BLOCKCHAIN_PRIVATE_KEY}

# Monitoring
MONITORING_ENABLED=true
METRICS_PORT=9090
PROMETHEUS_URL=http://prometheus:9090
GRAFANA_URL=http://grafana:3000
ALERTMANAGER_URL=http://alertmanager:9093

# Security
RATE_LIMITING_ENABLED=true
RATE_LIMITING_REQUESTS_PER_MINUTE=100
RATE_LIMITING_BURST_SIZE=200

# CORS
CORS_ENABLED=true
CORS_ALLOWED_ORIGINS=https://rechain-dao.com
CORS_ALLOWED_METHODS=GET,POST,PUT,DELETE
CORS_ALLOWED_HEADERS=Content-Type,Authorization
```

## Configuration Management

### Configuration Loader
```python
# config/loader.py
import os
import yaml
from typing import Dict, Any

class ConfigLoader:
    def __init__(self, environment: str = None):
        self.environment = environment or os.getenv('NODE_ENV', 'development')
        self.config = self.load_config()
    
    def load_config(self) -> Dict[str, Any]:
        """Load configuration based on environment"""
        config_file = f"config/{self.environment}.yml"
        
        if not os.path.exists(config_file):
            raise FileNotFoundError(f"Configuration file not found: {config_file}")
        
        with open(config_file, 'r') as f:
            config = yaml.safe_load(f)
        
        # Override with environment variables
        config = self.override_with_env_vars(config)
        
        return config
    
    def override_with_env_vars(self, config: Dict[str, Any]) -> Dict[str, Any]:
        """Override configuration with environment variables"""
        env_mappings = {
            'DB_HOST': 'database.host',
            'DB_PORT': 'database.port',
            'DB_NAME': 'database.name',
            'DB_USER': 'database.user',
            'DB_PASSWORD': 'database.password',
            'REDIS_HOST': 'redis.host',
            'REDIS_PORT': 'redis.port',
            'REDIS_PASSWORD': 'redis.password',
            'JWT_SECRET': 'jwt.secret',
            'JWT_EXPIRES_IN': 'jwt.expires_in',
            'SMTP_HOST': 'mail.host',
            'SMTP_PORT': 'mail.port',
            'SMTP_USER': 'mail.username',
            'SMTP_PASSWORD': 'mail.password',
        }
        
        for env_var, config_path in env_mappings.items():
            value = os.getenv(env_var)
            if value:
                self.set_nested_value(config, config_path, value)
        
        return config
    
    def set_nested_value(self, config: Dict[str, Any], path: str, value: Any):
        """Set nested configuration value"""
        keys = path.split('.')
        current = config
        
        for key in keys[:-1]:
            if key not in current:
                current[key] = {}
            current = current[key]
        
        current[keys[-1]] = value
    
    def get(self, key: str, default: Any = None) -> Any:
        """Get configuration value by key"""
        keys = key.split('.')
        current = self.config
        
        for key in keys:
            if isinstance(current, dict) and key in current:
                current = current[key]
            else:
                return default
        
        return current
```

### Environment Validation
```python
# config/validator.py
from typing import Dict, Any, List
import re

class ConfigValidator:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.errors = []
    
    def validate(self) -> List[str]:
        """Validate configuration"""
        self.validate_database()
        self.validate_redis()
        self.validate_jwt()
        self.validate_mail()
        self.validate_blockchain()
        self.validate_security()
        
        return self.errors
    
    def validate_database(self):
        """Validate database configuration"""
        db = self.config.get('database', {})
        
        if not db.get('host'):
            self.errors.append("Database host is required")
        
        if not db.get('name'):
            self.errors.append("Database name is required")
        
        if not db.get('user'):
            self.errors.append("Database user is required")
        
        if not db.get('password'):
            self.errors.append("Database password is required")
    
    def validate_redis(self):
        """Validate Redis configuration"""
        redis = self.config.get('redis', {})
        
        if not redis.get('host'):
            self.errors.append("Redis host is required")
        
        port = redis.get('port')
        if not port or not isinstance(port, int) or port < 1 or port > 65535:
            self.errors.append("Redis port must be a valid port number")
    
    def validate_jwt(self):
        """Validate JWT configuration"""
        jwt = self.config.get('jwt', {})
        
        if not jwt.get('secret'):
            self.errors.append("JWT secret is required")
        
        if len(jwt.get('secret', '')) < 32:
            self.errors.append("JWT secret must be at least 32 characters long")
    
    def validate_mail(self):
        """Validate mail configuration"""
        mail = self.config.get('mail', {})
        
        if not mail.get('host'):
            self.errors.append("Mail host is required")
        
        port = mail.get('port')
        if not port or not isinstance(port, int) or port < 1 or port > 65535:
            self.errors.append("Mail port must be a valid port number")
    
    def validate_blockchain(self):
        """Validate blockchain configuration"""
        blockchain = self.config.get('blockchain', {})
        
        if not blockchain.get('rpc_url'):
            self.errors.append("Blockchain RPC URL is required")
        
        if not blockchain.get('private_key'):
            self.errors.append("Blockchain private key is required")
    
    def validate_security(self):
        """Validate security configuration"""
        security = self.config.get('security', {})
        
        if security.get('rate_limiting', {}).get('enabled'):
            rate_limit = security['rate_limiting']
            
            if not rate_limit.get('requests_per_minute'):
                self.errors.append("Rate limiting requests per minute is required")
            
            if not rate_limit.get('burst_size'):
                self.errors.append("Rate limiting burst size is required")
```

## Conclusion

These environment templates provide comprehensive configurations for the REChain DAO platform across different environments. They include proper security settings, monitoring configurations, and environment-specific optimizations.

Remember: Always customize these templates based on your specific requirements and security policies. Regularly review and update the configurations to ensure they remain secure and effective.
