# SSL Certificates Setup

## Overview

This document provides comprehensive guidance for setting up and managing SSL certificates for the REChain DAO platform, including Let's Encrypt, commercial certificates, and automated renewal.

## Table of Contents

1. [Certificate Types](#certificate-types)
2. [Let's Encrypt Setup](#lets-encrypt-setup)
3. [Commercial Certificates](#commercial-certificates)
4. [Certificate Management](#certificate-management)
5. [Automation Scripts](#automation-scripts)
6. [Troubleshooting](#troubleshooting)

## Certificate Types

### Let's Encrypt (Recommended)
```yaml
advantages:
  - "Free and automated"
  - "Widely trusted"
  - "Easy renewal"
  - "Wildcard support"

limitations:
  - "90-day validity"
  - "Rate limits"
  - "No extended validation"
  - "Limited support"

use_cases:
  - "Development environments"
  - "Staging environments"
  - "Production with automation"
  - "Internal services"
```

### Commercial Certificates
```yaml
advantages:
  - "Extended validation"
  - "Longer validity (1-3 years)"
  - "Better support"
  - "No rate limits"

limitations:
  - "Cost"
  - "Manual renewal"
  - "Complex setup"
  - "Vendor dependency"

use_cases:
  - "Production environments"
  - "Enterprise customers"
  - "High-security requirements"
  - "Compliance requirements"
```

## Let's Encrypt Setup

### Installation
```bash
#!/bin/bash
# install-letsencrypt.sh

set -e

# Update system
apt-get update
apt-get upgrade -y

# Install certbot
apt-get install -y certbot python3-certbot-nginx

# Verify installation
certbot --version

echo "Let's Encrypt installation completed successfully!"
```

### Basic Certificate Request
```bash
#!/bin/bash
# request-certificate.sh

set -e

# Configuration
DOMAIN=$1
EMAIL=$2
WEBROOT="/var/www/html"

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo "Usage: $0 <domain> <email>"
    echo "Example: $0 api.rechain-dao.com admin@rechain-dao.com"
    exit 1
fi

echo "Requesting SSL certificate for $DOMAIN..."

# Create webroot directory
mkdir -p $WEBROOT

# Request certificate
certbot certonly \
    --webroot \
    --webroot-path=$WEBROOT \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    --domains $DOMAIN

# Verify certificate
if [ -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
    echo "Certificate created successfully!"
    echo "Certificate location: /etc/letsencrypt/live/$DOMAIN/"
    echo "Files:"
    echo "  - fullchain.pem (certificate + chain)"
    echo "  - privkey.pem (private key)"
    echo "  - cert.pem (certificate only)"
    echo "  - chain.pem (chain only)"
else
    echo "Certificate creation failed!"
    exit 1
fi
```

### Wildcard Certificate
```bash
#!/bin/bash
# request-wildcard-certificate.sh

set -e

# Configuration
DOMAIN=$1
EMAIL=$2
DNS_PLUGIN=$3

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ] || [ -z "$DNS_PLUGIN" ]; then
    echo "Usage: $0 <domain> <email> <dns-plugin>"
    echo "Example: $0 rechain-dao.com admin@rechain-dao.com cloudflare"
    echo "Available plugins: cloudflare, route53, digitalocean, etc."
    exit 1
fi

echo "Requesting wildcard certificate for *.$DOMAIN..."

# Install DNS plugin
case $DNS_PLUGIN in
    cloudflare)
        apt-get install -y python3-certbot-dns-cloudflare
        ;;
    route53)
        apt-get install -y python3-certbot-dns-route53
        ;;
    digitalocean)
        apt-get install -y python3-certbot-dns-digitalocean
        ;;
    *)
        echo "Unsupported DNS plugin: $DNS_PLUGIN"
        exit 1
        ;;
esac

# Request wildcard certificate
certbot certonly \
    --dns-$DNS_PLUGIN \
    --dns-$DNS_PLUGIN-credentials /etc/letsencrypt/dns-$DNS_PLUGIN.ini \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    --domains "*.$DOMAIN"

echo "Wildcard certificate created successfully!"
```

## Commercial Certificates

### Certificate Request Process
```bash
#!/bin/bash
# request-commercial-certificate.sh

set -e

# Configuration
DOMAIN=$1
EMAIL=$2
COUNTRY="US"
STATE="California"
CITY="San Francisco"
ORG="REChain DAO"
OU="IT Department"

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo "Usage: $0 <domain> <email>"
    echo "Example: $0 api.rechain-dao.com admin@rechain-dao.com"
    exit 1
fi

echo "Generating certificate signing request for $DOMAIN..."

# Create private key
openssl genrsa -out /etc/ssl/private/$DOMAIN.key 2048

# Create certificate signing request
openssl req -new -key /etc/ssl/private/$DOMAIN.key -out /etc/ssl/csr/$DOMAIN.csr -subj "/C=$COUNTRY/ST=$STATE/L=$CITY/O=$ORG/OU=$OU/CN=$DOMAIN/emailAddress=$EMAIL"

# Set permissions
chmod 600 /etc/ssl/private/$DOMAIN.key
chmod 644 /etc/ssl/csr/$DOMAIN.csr

echo "Certificate signing request created:"
echo "  Private key: /etc/ssl/private/$DOMAIN.key"
echo "  CSR: /etc/ssl/csr/$DOMAIN.csr"
echo ""
echo "Submit the CSR to your certificate authority:"
echo "  cat /etc/ssl/csr/$DOMAIN.csr"
```

### Certificate Installation
```bash
#!/bin/bash
# install-commercial-certificate.sh

set -e

# Configuration
DOMAIN=$1
CERT_FILE=$2
CHAIN_FILE=$3

if [ -z "$DOMAIN" ] || [ -z "$CERT_FILE" ] || [ -z "$CHAIN_FILE" ]; then
    echo "Usage: $0 <domain> <cert-file> <chain-file>"
    echo "Example: $0 api.rechain-dao.com certificate.crt chain.crt"
    exit 1
fi

echo "Installing commercial certificate for $DOMAIN..."

# Create certificate directory
mkdir -p /etc/ssl/certs/$DOMAIN

# Copy certificate files
cp $CERT_FILE /etc/ssl/certs/$DOMAIN/cert.pem
cp $CHAIN_FILE /etc/ssl/certs/$DOMAIN/chain.pem

# Combine certificate and chain
cat /etc/ssl/certs/$DOMAIN/cert.pem /etc/ssl/certs/$DOMAIN/chain.pem > /etc/ssl/certs/$DOMAIN/fullchain.pem

# Set permissions
chmod 644 /etc/ssl/certs/$DOMAIN/*.pem

# Verify certificate
openssl x509 -in /etc/ssl/certs/$DOMAIN/fullchain.pem -text -noout

echo "Certificate installed successfully!"
echo "Certificate location: /etc/ssl/certs/$DOMAIN/"
```

## Certificate Management

### Certificate Monitoring
```bash
#!/bin/bash
# monitor-certificates.sh

set -e

# Configuration
CERT_DIR="/etc/letsencrypt/live"
WARNING_DAYS=30
CRITICAL_DAYS=7

echo "Checking SSL certificate expiration..."

for cert_dir in $CERT_DIR/*; do
    if [ -d "$cert_dir" ]; then
        domain=$(basename $cert_dir)
        cert_file="$cert_dir/fullchain.pem"
        
        if [ -f "$cert_file" ]; then
            # Get expiration date
            expiry_date=$(openssl x509 -in $cert_file -enddate -noout | cut -d= -f2)
            expiry_timestamp=$(date -d "$expiry_date" +%s)
            current_timestamp=$(date +%s)
            days_until_expiry=$(( (expiry_timestamp - current_timestamp) / 86400 ))
            
            echo "Domain: $domain"
            echo "  Expires: $expiry_date"
            echo "  Days until expiry: $days_until_expiry"
            
            if [ $days_until_expiry -le $CRITICAL_DAYS ]; then
                echo "  Status: CRITICAL - Certificate expires in $days_until_expiry days!"
            elif [ $days_until_expiry -le $WARNING_DAYS ]; then
                echo "  Status: WARNING - Certificate expires in $days_until_expiry days"
            else
                echo "  Status: OK - Certificate expires in $days_until_expiry days"
            fi
            echo ""
        fi
    fi
done
```

### Certificate Backup
```bash
#!/bin/bash
# backup-certificates.sh

set -e

# Configuration
BACKUP_DIR="/opt/backups/ssl"
DATE=$(date +%Y%m%d_%H%M%S)
CERT_DIR="/etc/letsencrypt/live"

echo "Backing up SSL certificates..."

# Create backup directory
mkdir -p $BACKUP_DIR/$DATE

# Backup Let's Encrypt certificates
if [ -d "$CERT_DIR" ]; then
    cp -r $CERT_DIR $BACKUP_DIR/$DATE/letsencrypt
    echo "Let's Encrypt certificates backed up"
fi

# Backup commercial certificates
if [ -d "/etc/ssl/certs" ]; then
    cp -r /etc/ssl/certs $BACKUP_DIR/$DATE/commercial
    echo "Commercial certificates backed up"
fi

# Backup private keys
if [ -d "/etc/ssl/private" ]; then
    cp -r /etc/ssl/private $BACKUP_DIR/$DATE/private
    echo "Private keys backed up"
fi

# Create archive
cd $BACKUP_DIR
tar -czf ssl_certificates_$DATE.tar.gz $DATE
rm -rf $DATE

echo "SSL certificates backed up to: $BACKUP_DIR/ssl_certificates_$DATE.tar.gz"
```

## Automation Scripts

### Auto-Renewal Setup
```bash
#!/bin/bash
# setup-auto-renewal.sh

set -e

echo "Setting up automatic certificate renewal..."

# Create renewal script
cat > /usr/local/bin/renew-certificates.sh << 'EOF'
#!/bin/bash
# Auto-renewal script for SSL certificates

set -e

LOG_FILE="/var/log/ssl-renewal.log"
EMAIL="admin@rechain-dao.com"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

log "Starting certificate renewal process..."

# Renew Let's Encrypt certificates
if command -v certbot &> /dev/null; then
    log "Renewing Let's Encrypt certificates..."
    certbot renew --quiet --no-self-upgrade
    
    if [ $? -eq 0 ]; then
        log "Let's Encrypt certificates renewed successfully"
        
        # Reload Nginx
        systemctl reload nginx
        log "Nginx reloaded"
    else
        log "ERROR: Let's Encrypt certificate renewal failed"
        echo "Certificate renewal failed for Let's Encrypt" | mail -s "SSL Certificate Renewal Failed" $EMAIL
    fi
fi

# Check commercial certificates
COMMERCIAL_CERT_DIR="/etc/ssl/certs"
if [ -d "$COMMERCIAL_CERT_DIR" ]; then
    for cert_file in $COMMERCIAL_CERT_DIR/*/fullchain.pem; do
        if [ -f "$cert_file" ]; then
            domain=$(basename $(dirname $cert_file))
            expiry_date=$(openssl x509 -in $cert_file -enddate -noout | cut -d= -f2)
            expiry_timestamp=$(date -d "$expiry_date" +%s)
            current_timestamp=$(date +%s)
            days_until_expiry=$(( (expiry_timestamp - current_timestamp) / 86400 ))
            
            if [ $days_until_expiry -le 30 ]; then
                log "WARNING: Commercial certificate for $domain expires in $days_until_expiry days"
                echo "Commercial certificate for $domain expires in $days_until_expiry days" | mail -s "SSL Certificate Expiring Soon" $EMAIL
            fi
        fi
    done
fi

log "Certificate renewal process completed"
EOF

# Make script executable
chmod +x /usr/local/bin/renew-certificates.sh

# Add to crontab
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/renew-certificates.sh") | crontab -

echo "Auto-renewal setup completed!"
echo "Certificates will be renewed daily at 2:00 AM"
echo "Logs will be written to: /var/log/ssl-renewal.log"
```

### Nginx SSL Configuration
```bash
#!/bin/bash
# configure-nginx-ssl.sh

set -e

# Configuration
DOMAIN=$1
CERT_TYPE=${2:-letsencrypt}

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain> [cert-type]"
    echo "Example: $0 api.rechain-dao.com letsencrypt"
    echo "Example: $0 api.rechain-dao.com commercial"
    exit 1
fi

echo "Configuring Nginx SSL for $DOMAIN with $CERT_TYPE certificate..."

# Set certificate paths
if [ "$CERT_TYPE" = "letsencrypt" ]; then
    CERT_PATH="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
    KEY_PATH="/etc/letsencrypt/live/$DOMAIN/privkey.pem"
elif [ "$CERT_TYPE" = "commercial" ]; then
    CERT_PATH="/etc/ssl/certs/$DOMAIN/fullchain.pem"
    KEY_PATH="/etc/ssl/private/$DOMAIN.key"
else
    echo "Invalid certificate type: $CERT_TYPE"
    exit 1
fi

# Verify certificate files exist
if [ ! -f "$CERT_PATH" ] || [ ! -f "$KEY_PATH" ]; then
    echo "Certificate files not found:"
    echo "  Certificate: $CERT_PATH"
    echo "  Private key: $KEY_PATH"
    exit 1
fi

# Create Nginx SSL configuration
cat > /etc/nginx/sites-available/$DOMAIN-ssl << EOF
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name $DOMAIN;
    
    # SSL Configuration
    ssl_certificate $CERT_PATH;
    ssl_certificate_key $KEY_PATH;
    
    # SSL Security
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_session_tickets off;
    
    # HSTS
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    
    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Your application configuration here
    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

# HTTP to HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN;
    return 301 https://\$server_name\$request_uri;
}
EOF

# Enable site
ln -sf /etc/nginx/sites-available/$DOMAIN-ssl /etc/nginx/sites-enabled/

# Test Nginx configuration
nginx -t

if [ $? -eq 0 ]; then
    echo "Nginx configuration test passed. Reloading Nginx..."
    systemctl reload nginx
    echo "SSL configuration completed successfully!"
else
    echo "Nginx configuration test failed. Please check the configuration."
    exit 1
fi
```

## Troubleshooting

### Common Issues
```yaml
issue: "Certificate not found"
symptoms:
  - "Nginx fails to start"
  - "SSL errors in logs"
  - "Certificate file not found"

solutions:
  - "Check certificate file path"
  - "Verify certificate exists"
  - "Check file permissions"
  - "Regenerate certificate"

commands:
  - "ls -la /etc/letsencrypt/live/$DOMAIN/"
  - "nginx -t"
  - "systemctl status nginx"
  - "certbot certificates"

issue: "Certificate expired"
symptoms:
  - "Browser shows certificate error"
  - "SSL handshake fails"
  - "Certificate expired message"

solutions:
  - "Renew certificate"
  - "Check auto-renewal"
  - "Manual renewal"
  - "Update certificate"

commands:
  - "certbot renew"
  - "certbot renew --force-renewal"
  - "systemctl reload nginx"
  - "openssl x509 -in /path/to/cert.pem -text -noout"

issue: "Rate limit exceeded"
symptoms:
  - "Too many requests error"
  - "Certificate renewal fails"
  - "Rate limit message"

solutions:
  - "Wait for rate limit reset"
  - "Use staging environment"
  - "Request fewer certificates"
  - "Contact Let's Encrypt"

commands:
  - "certbot renew --dry-run"
  - "certbot certificates"
  - "certbot renew --staging"
```

### Diagnostic Script
```bash
#!/bin/bash
# ssl-diagnostics.sh

set -e

# Configuration
DOMAIN=$1

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain>"
    echo "Example: $0 api.rechain-dao.com"
    exit 1
fi

echo "SSL Diagnostics for $DOMAIN"
echo "=========================="

# Check certificate files
echo "1. Checking certificate files..."
if [ -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
    echo "  ✓ Let's Encrypt certificate found"
    CERT_FILE="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
elif [ -f "/etc/ssl/certs/$DOMAIN/fullchain.pem" ]; then
    echo "  ✓ Commercial certificate found"
    CERT_FILE="/etc/ssl/certs/$DOMAIN/fullchain.pem"
else
    echo "  ✗ No certificate found for $DOMAIN"
    exit 1
fi

# Check certificate validity
echo "2. Checking certificate validity..."
if [ -f "$CERT_FILE" ]; then
    expiry_date=$(openssl x509 -in $CERT_FILE -enddate -noout | cut -d= -f2)
    expiry_timestamp=$(date -d "$expiry_date" +%s)
    current_timestamp=$(date +%s)
    days_until_expiry=$(( (expiry_timestamp - current_timestamp) / 86400 ))
    
    echo "  Expiry date: $expiry_date"
    echo "  Days until expiry: $days_until_expiry"
    
    if [ $days_until_expiry -le 0 ]; then
        echo "  ✗ Certificate has expired!"
    elif [ $days_until_expiry -le 30 ]; then
        echo "  ⚠ Certificate expires soon!"
    else
        echo "  ✓ Certificate is valid"
    fi
fi

# Check certificate chain
echo "3. Checking certificate chain..."
if [ -f "$CERT_FILE" ]; then
    openssl verify -CAfile /etc/ssl/certs/ca-certificates.crt $CERT_FILE
    if [ $? -eq 0 ]; then
        echo "  ✓ Certificate chain is valid"
    else
        echo "  ✗ Certificate chain is invalid"
    fi
fi

# Check Nginx configuration
echo "4. Checking Nginx configuration..."
nginx -t
if [ $? -eq 0 ]; then
    echo "  ✓ Nginx configuration is valid"
else
    echo "  ✗ Nginx configuration has errors"
fi

# Check SSL handshake
echo "5. Checking SSL handshake..."
echo | openssl s_client -connect $DOMAIN:443 -servername $DOMAIN 2>/dev/null | openssl x509 -noout -dates
if [ $? -eq 0 ]; then
    echo "  ✓ SSL handshake successful"
else
    echo "  ✗ SSL handshake failed"
fi

# Check certificate details
echo "6. Certificate details..."
if [ -f "$CERT_FILE" ]; then
    echo "  Subject: $(openssl x509 -in $CERT_FILE -subject -noout | cut -d= -f2-)"
    echo "  Issuer: $(openssl x509 -in $CERT_FILE -issuer -noout | cut -d= -f2-)"
    echo "  Serial: $(openssl x509 -in $CERT_FILE -serial -noout | cut -d= -f2)"
    echo "  Fingerprint: $(openssl x509 -in $CERT_FILE -fingerprint -noout | cut -d= -f2)"
fi

echo "SSL diagnostics completed!"
```

## Conclusion

This SSL certificate setup guide provides comprehensive instructions for managing SSL certificates for the REChain DAO platform, including Let's Encrypt, commercial certificates, automation, and troubleshooting. It ensures secure communication and proper certificate management.

Remember: Always test SSL configurations in a staging environment before deploying to production. Regularly monitor certificate expiration and maintain proper backups of certificate files and private keys.
