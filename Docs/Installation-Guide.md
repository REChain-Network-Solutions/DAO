# REChain DAO - Installation Guide

## Prerequisites

### System Requirements

**Minimum Requirements:**
- PHP 8.2 or higher
- MySQL 5.7+ or MariaDB 10.3+
- Apache 2.4+ or Nginx 1.18+
- 2GB RAM minimum
- 10GB free disk space

**Recommended Requirements:**
- PHP 8.3+
- MySQL 8.0+ or MariaDB 10.6+
- Apache 2.4+ with mod_rewrite or Nginx 1.20+
- 4GB RAM or more
- 50GB+ free disk space
- SSD storage

### Required PHP Extensions

Ensure the following PHP extensions are installed and enabled:

```bash
# Core extensions
php-mysqli
php-curl
php-mbstring
php-gd
php-fileinfo
php-zip
php-json
php-xml
php-intl

# Optional but recommended
php-opcache
php-redis
php-memcached
php-imagick
```

### Web Server Configuration

#### Apache Configuration

Create or update your `.htaccess` file:

```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php [QSA,L]

# Security headers
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options DENY
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"

# File upload limits
php_value upload_max_filesize 100M
php_value post_max_size 100M
php_value max_execution_time 300
php_value memory_limit 256M
```

#### Nginx Configuration

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/html/dao;
    index index.php;

    # Security headers
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
    add_header X-XSS-Protection "1; mode=block";
    add_header Referrer-Policy "strict-origin-when-cross-origin";

    # File upload limits
    client_max_body_size 100M;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Deny access to sensitive files
    location ~ /\.(ht|env) {
        deny all;
    }
}
```

## Installation Methods

### Method 1: Manual Installation

#### Step 1: Download and Extract

```bash
# Clone the repository
git clone https://github.com/REChain-Network-Solutions/DAO.git
cd DAO

# Or download and extract ZIP
wget https://github.com/REChain-Network-Solutions/DAO/archive/main.zip
unzip main.zip
cd DAO-main
```

#### Step 2: Set Permissions

```bash
# Set proper permissions
chmod -R 755 .
chmod -R 777 content/uploads/
chmod -R 777 content/backups/
chmod -R 777 includes/config.php

# Set ownership (replace www-data with your web server user)
chown -R www-data:www-data .
```

#### Step 3: Install Dependencies

```bash
# Install PHP dependencies
composer install --no-dev --optimize-autoloader

# Install Node.js dependencies (if needed)
npm install --production
```

#### Step 4: Database Setup

1. Create a MySQL database:
```sql
CREATE DATABASE rechain_dao CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'dao_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON rechain_dao.* TO 'dao_user'@'localhost';
FLUSH PRIVILEGES;
```

2. Import the database schema:
```bash
mysql -u dao_user -p rechain_dao < Extras/SQL/schema.sql
```

#### Step 5: Configuration

1. Copy the configuration template:
```bash
cp includes/config-example.php includes/config.php
```

2. Edit `includes/config.php` with your settings:
```php
<?php
// Database configuration
define('DB_NAME', 'rechain_dao');
define('DB_USER', 'dao_user');
define('DB_PASSWORD', 'secure_password');
define('DB_HOST', 'localhost');
define('DB_PORT', '3306');

// System URL
define('SYS_URL', 'https://your-domain.com');

// Security settings
define('URL_CHECK', 'true');
define('DEBUGGING', false);

// License key (if applicable)
define('LICENCE_KEY', 'your_license_key');
```

#### Step 6: Run the Installer

1. Navigate to `http://your-domain.com/install.php`
2. Follow the installation wizard
3. Complete the setup process

### Method 2: Docker Installation

#### Step 1: Clone Repository

```bash
git clone https://github.com/REChain-Network-Solutions/DAO.git
cd DAO
```

#### Step 2: Configure Environment

Create `.env` file:
```env
# Database
DB_HOST=mysql
DB_PORT=3306
DB_NAME=rechain_dao
DB_USER=dao_user
DB_PASSWORD=secure_password

# Application
SYS_URL=http://localhost:8080
DEBUGGING=false
LICENCE_KEY=your_license_key

# Redis (optional)
REDIS_HOST=redis
REDIS_PORT=6379
```

#### Step 3: Start Services

```bash
# Start all services
docker-compose up -d

# Check logs
docker-compose logs -f
```

#### Step 4: Initialize Database

```bash
# Run database migrations
docker-compose exec web php install.php
```

### Method 3: Cloud Installation

#### AWS EC2 Installation

1. Launch an EC2 instance (Ubuntu 22.04 LTS)
2. Install LAMP stack:
```bash
sudo apt update
sudo apt install apache2 mysql-server php8.3 php8.3-mysql php8.3-curl php8.3-mbstring php8.3-gd php8.3-zip composer
```

3. Follow manual installation steps

#### DigitalOcean Droplet

1. Create a droplet with LAMP stack
2. Follow manual installation steps
3. Configure SSL with Let's Encrypt

## Post-Installation Configuration

### 1. SSL Certificate Setup

#### Using Let's Encrypt (Certbot)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-apache

# Obtain certificate
sudo certbot --apache -d your-domain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### 2. Database Optimization

```sql
-- Optimize MySQL settings
SET GLOBAL innodb_buffer_pool_size = 1G;
SET GLOBAL max_connections = 200;
SET GLOBAL query_cache_size = 64M;
```

### 3. PHP Configuration

Edit `/etc/php/8.3/apache2/php.ini`:

```ini
# Performance settings
memory_limit = 256M
max_execution_time = 300
max_input_time = 300
upload_max_filesize = 100M
post_max_size = 100M

# Security settings
expose_php = Off
allow_url_fopen = Off
allow_url_include = Off

# OPcache settings
opcache.enable = 1
opcache.memory_consumption = 128
opcache.max_accelerated_files = 4000
opcache.revalidate_freq = 2
```

### 4. Cron Jobs Setup

```bash
# Edit crontab
crontab -e

# Add these jobs
# Clean temporary files every hour
0 * * * * find /var/www/html/dao/content/uploads/temp -type f -mtime +1 -delete

# Database backup daily at 2 AM
0 2 * * * mysqldump -u dao_user -p'secure_password' rechain_dao > /var/backups/dao_$(date +\%Y\%m\%d).sql

# Clear cache every 6 hours
0 */6 * * * rm -rf /var/www/html/dao/content/cache/*
```

## Verification and Testing

### 1. System Check

Visit `http://your-domain.com/admin` and check:
- Database connection
- File permissions
- PHP extensions
- System requirements

### 2. Performance Testing

```bash
# Test with Apache Bench
ab -n 1000 -c 10 http://your-domain.com/

# Test with curl
curl -I http://your-domain.com/
```

### 3. Security Testing

```bash
# Check for common vulnerabilities
nmap -sV -sC your-domain.com

# Test SSL configuration
sslscan your-domain.com
```

## Troubleshooting

### Common Issues

#### 1. Database Connection Error

**Error**: `Could not connect to database`

**Solution**:
- Check database credentials in `config.php`
- Verify MySQL service is running
- Check firewall settings

#### 2. File Permission Errors

**Error**: `Permission denied`

**Solution**:
```bash
chmod -R 755 .
chmod -R 777 content/uploads/
chown -R www-data:www-data .
```

#### 3. Memory Limit Exceeded

**Error**: `Fatal error: Allowed memory size exhausted`

**Solution**:
- Increase `memory_limit` in `php.ini`
- Optimize database queries
- Enable OPcache

#### 4. 500 Internal Server Error

**Solution**:
- Check Apache/Nginx error logs
- Verify `.htaccess` configuration
- Check PHP error logs

### Log Files

**Apache Logs**:
- Error log: `/var/log/apache2/error.log`
- Access log: `/var/log/apache2/access.log`

**Nginx Logs**:
- Error log: `/var/log/nginx/error.log`
- Access log: `/var/log/nginx/access.log`

**PHP Logs**:
- Error log: `/var/log/php8.3/error.log`

**Application Logs**:
- System log: `content/logs/system.log`
- Error log: `content/logs/error.log`

## Maintenance

### Regular Maintenance Tasks

1. **Database Maintenance**:
   - Regular backups
   - Query optimization
   - Index maintenance

2. **File System Maintenance**:
   - Clean temporary files
   - Monitor disk usage
   - Update file permissions

3. **Security Updates**:
   - Update PHP version
   - Update dependencies
   - Security patches

4. **Performance Monitoring**:
   - Monitor server resources
   - Analyze slow queries
   - Optimize caching

### Backup Strategy

```bash
#!/bin/bash
# Backup script
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/dao"

# Create backup directory
mkdir -p $BACKUP_DIR

# Database backup
mysqldump -u dao_user -p'secure_password' rechain_dao > $BACKUP_DIR/db_$DATE.sql

# Files backup
tar -czf $BACKUP_DIR/files_$DATE.tar.gz /var/www/html/dao

# Clean old backups (keep 30 days)
find $BACKUP_DIR -name "*.sql" -mtime +30 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete
```

## Support

For additional support:

- **Documentation**: Check the `/docs` directory
- **Issues**: Report on GitHub Issues
- **Community**: Join our Discord server
- **Email**: support@rechain.network

---

*This installation guide covers the complete setup process for REChain DAO. For advanced configuration options, refer to the specific component documentation.*
