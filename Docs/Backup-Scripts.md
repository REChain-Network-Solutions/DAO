# Backup Scripts

## Overview

This document provides comprehensive backup scripts for the REChain DAO platform, including database backups, file backups, and disaster recovery procedures.

## Table of Contents

1. [Database Backup Scripts](#database-backup-scripts)
2. [File System Backups](#file-system-backups)
3. [Configuration Backups](#configuration-backups)
4. [Automated Backup System](#automated-backup-system)
5. [Restore Procedures](#restore-procedures)
6. [Backup Validation](#backup-validation)

## Database Backup Scripts

### MySQL Backup Script
```bash
#!/bin/bash
# mysql-backup.sh

set -e

# Configuration
BACKUP_DIR="/opt/backups/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
DB_HOST="mysql-service"
DB_NAME="rechain_dao"
DB_USER="backup_user"
DB_PASSWORD=""
RETENTION_DAYS=30
S3_BUCKET="rechain-dao-backups"
S3_PREFIX="mysql"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup directory
mkdir -p $BACKUP_DIR

log_info "Starting MySQL backup for database: $DB_NAME"

# Create full backup
log_info "Creating full backup..."
mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASSWORD \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    --hex-blob \
    --opt \
    $DB_NAME > $BACKUP_DIR/mysql_full_$DATE.sql

# Compress backup
log_info "Compressing backup..."
gzip $BACKUP_DIR/mysql_full_$DATE.sql

# Upload to S3
log_info "Uploading backup to S3..."
aws s3 cp $BACKUP_DIR/mysql_full_$DATE.sql.gz s3://$S3_BUCKET/$S3_PREFIX/

# Verify backup
log_info "Verifying backup..."
if [ -f "$BACKUP_DIR/mysql_full_$DATE.sql.gz" ]; then
    BACKUP_SIZE=$(du -h $BACKUP_DIR/mysql_full_$DATE.sql.gz | cut -f1)
    log_info "Backup created successfully: mysql_full_$DATE.sql.gz ($BACKUP_SIZE)"
else
    log_error "Backup file not found!"
    exit 1
fi

# Cleanup old backups
log_info "Cleaning up old backups..."
find $BACKUP_DIR -name "mysql_full_*.sql.gz" -mtime +$RETENTION_DAYS -delete

# Cleanup S3 old backups
log_info "Cleaning up old S3 backups..."
aws s3 ls s3://$S3_BUCKET/$S3_PREFIX/ | \
    awk '{print $4}' | \
    grep "mysql_full_" | \
    sort -r | \
    tail -n +$((RETENTION_DAYS + 1)) | \
    while read file; do
        aws s3 rm s3://$S3_BUCKET/$S3_PREFIX/$file
    done

log_success "MySQL backup completed successfully!"
```

### Incremental Backup Script
```bash
#!/bin/bash
# mysql-incremental-backup.sh

set -e

# Configuration
BACKUP_DIR="/opt/backups/mysql/incremental"
DATE=$(date +%Y%m%d_%H%M%S)
DB_HOST="mysql-service"
DB_NAME="rechain_dao"
DB_USER="backup_user"
DB_PASSWORD=""
BINLOG_DIR="/var/lib/mysql"
S3_BUCKET="rechain-dao-backups"
S3_PREFIX="mysql/incremental"

log_info "Starting incremental MySQL backup..."

# Create backup directory
mkdir -p $BACKUP_DIR

# Get current binlog position
log_info "Getting current binlog position..."
BINLOG_POSITION=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "SHOW MASTER STATUS\G" | grep Position | awk '{print $2}')
BINLOG_FILE=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "SHOW MASTER STATUS\G" | grep File | awk '{print $2}')

log_info "Current binlog position: $BINLOG_FILE:$BINLOG_POSITION"

# Flush logs to create new binlog
log_info "Flushing binary logs..."
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "FLUSH LOGS;"

# Copy binlog files
log_info "Copying binlog files..."
cp $BINLOG_DIR/$BINLOG_FILE $BACKUP_DIR/

# Compress backup
log_info "Compressing backup..."
tar -czf $BACKUP_DIR/incremental_$DATE.tar.gz -C $BACKUP_DIR $BINLOG_FILE

# Upload to S3
log_info "Uploading backup to S3..."
aws s3 cp $BACKUP_DIR/incremental_$DATE.tar.gz s3://$S3_BUCKET/$S3_PREFIX/

# Cleanup local files
rm $BACKUP_DIR/$BINLOG_FILE
rm $BACKUP_DIR/incremental_$DATE.tar.gz

log_success "Incremental backup completed successfully!"
```

## File System Backups

### Application Files Backup
```bash
#!/bin/bash
# app-files-backup.sh

set -e

# Configuration
BACKUP_DIR="/opt/backups/files"
DATE=$(date +%Y%m%d_%H%M%S)
SOURCE_DIR="/var/www/rechain-dao"
S3_BUCKET="rechain-dao-backups"
S3_PREFIX="files"
RETENTION_DAYS=30

log_info "Starting application files backup..."

# Create backup directory
mkdir -p $BACKUP_DIR

# Create tar archive
log_info "Creating tar archive..."
tar -czf $BACKUP_DIR/app_files_$DATE.tar.gz \
    --exclude="node_modules" \
    --exclude=".git" \
    --exclude="*.log" \
    --exclude="tmp" \
    -C $SOURCE_DIR .

# Upload to S3
log_info "Uploading backup to S3..."
aws s3 cp $BACKUP_DIR/app_files_$DATE.tar.gz s3://$S3_BUCKET/$S3_PREFIX/

# Verify backup
BACKUP_SIZE=$(du -h $BACKUP_DIR/app_files_$DATE.tar.gz | cut -f1)
log_info "Backup created successfully: app_files_$DATE.tar.gz ($BACKUP_SIZE)"

# Cleanup old backups
log_info "Cleaning up old backups..."
find $BACKUP_DIR -name "app_files_*.tar.gz" -mtime +$RETENTION_DAYS -delete

log_success "Application files backup completed successfully!"
```

### Configuration Backup
```bash
#!/bin/bash
# config-backup.sh

set -e

# Configuration
BACKUP_DIR="/opt/backups/config"
DATE=$(date +%Y%m%d_%H%M%S)
CONFIG_DIRS=(
    "/etc/nginx"
    "/etc/ssl"
    "/etc/letsencrypt"
    "/opt/rechain-dao/config"
    "/opt/rechain-dao/k8s"
)
S3_BUCKET="rechain-dao-backups"
S3_PREFIX="config"

log_info "Starting configuration backup..."

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup each configuration directory
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        log_info "Backing up $dir..."
        dir_name=$(basename $dir)
        tar -czf $BACKUP_DIR/${dir_name}_$DATE.tar.gz -C $(dirname $dir) $dir_name
    else
        log_warning "Directory $dir not found, skipping..."
    fi
done

# Create combined backup
log_info "Creating combined configuration backup..."
tar -czf $BACKUP_DIR/all_config_$DATE.tar.gz -C $BACKUP_DIR *.tar.gz

# Upload to S3
log_info "Uploading backup to S3..."
aws s3 cp $BACKUP_DIR/all_config_$DATE.tar.gz s3://$S3_BUCKET/$S3_PREFIX/

# Cleanup local files
rm $BACKUP_DIR/*_$DATE.tar.gz

log_success "Configuration backup completed successfully!"
```

## Automated Backup System

### Master Backup Script
```bash
#!/bin/bash
# master-backup.sh

set -e

# Configuration
BACKUP_DIR="/opt/backups"
LOG_FILE="/var/log/backup.log"
S3_BUCKET="rechain-dao-backups"
NOTIFICATION_EMAIL="admin@rechain-dao.com"
SLACK_WEBHOOK="https://hooks.slack.com/services/..."

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Notification function
send_notification() {
    local status=$1
    local message=$2
    
    # Email notification
    echo "$message" | mail -s "Backup $status - $(date)" $NOTIFICATION_EMAIL
    
    # Slack notification
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"Backup $status: $message\"}" \
        $SLACK_WEBHOOK
}

# Error handling
handle_error() {
    local exit_code=$1
    local script_name=$2
    
    if [ $exit_code -ne 0 ]; then
        log "ERROR: $script_name failed with exit code $exit_code"
        send_notification "FAILED" "$script_name backup failed"
        exit $exit_code
    fi
}

log "Starting master backup process..."

# Run database backup
log "Running MySQL backup..."
bash /opt/scripts/mysql-backup.sh
handle_error $? "MySQL"

# Run incremental backup
log "Running incremental backup..."
bash /opt/scripts/mysql-incremental-backup.sh
handle_error $? "MySQL Incremental"

# Run application files backup
log "Running application files backup..."
bash /opt/scripts/app-files-backup.sh
handle_error $? "Application Files"

# Run configuration backup
log "Running configuration backup..."
bash /opt/scripts/config-backup.sh
handle_error $? "Configuration"

# Run Kubernetes backup
log "Running Kubernetes backup..."
bash /opt/scripts/k8s-backup.sh
handle_error $? "Kubernetes"

# Generate backup report
log "Generating backup report..."
bash /opt/scripts/backup-report.sh

# Send success notification
send_notification "SUCCESS" "All backups completed successfully"

log "Master backup process completed successfully!"
```

### Kubernetes Backup Script
```bash
#!/bin/bash
# k8s-backup.sh

set -e

# Configuration
BACKUP_DIR="/opt/backups/k8s"
DATE=$(date +%Y%m%d_%H%M%S)
NAMESPACE="rechain-dao"
S3_BUCKET="rechain-dao-backups"
S3_PREFIX="k8s"

log_info "Starting Kubernetes backup..."

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup all resources in namespace
log_info "Backing up Kubernetes resources..."
kubectl get all -n $NAMESPACE -o yaml > $BACKUP_DIR/k8s_resources_$DATE.yaml

# Backup ConfigMaps
log_info "Backing up ConfigMaps..."
kubectl get configmaps -n $NAMESPACE -o yaml > $BACKUP_DIR/configmaps_$DATE.yaml

# Backup Secrets
log_info "Backing up Secrets..."
kubectl get secrets -n $NAMESPACE -o yaml > $BACKUP_DIR/secrets_$DATE.yaml

# Backup PersistentVolumeClaims
log_info "Backing up PVCs..."
kubectl get pvc -n $NAMESPACE -o yaml > $BACKUP_DIR/pvcs_$DATE.yaml

# Create combined backup
log_info "Creating combined backup..."
tar -czf $BACKUP_DIR/k8s_backup_$DATE.tar.gz -C $BACKUP_DIR *.yaml

# Upload to S3
log_info "Uploading backup to S3..."
aws s3 cp $BACKUP_DIR/k8s_backup_$DATE.tar.gz s3://$S3_BUCKET/$S3_PREFIX/

# Cleanup local files
rm $BACKUP_DIR/*.yaml
rm $BACKUP_DIR/k8s_backup_$DATE.tar.gz

log_success "Kubernetes backup completed successfully!"
```

## Restore Procedures

### Database Restore Script
```bash
#!/bin/bash
# mysql-restore.sh

set -e

# Configuration
BACKUP_FILE=$1
DB_HOST="mysql-service"
DB_NAME="rechain_dao"
DB_USER="restore_user"
DB_PASSWORD=""
TEMP_DIR="/tmp/restore"

if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup_file>"
    echo "Example: $0 mysql_full_20240101_120000.sql.gz"
    exit 1
fi

log_info "Starting MySQL restore from: $BACKUP_FILE"

# Create temporary directory
mkdir -p $TEMP_DIR

# Download backup from S3 if needed
if [[ $BACKUP_FILE == s3://* ]]; then
    log_info "Downloading backup from S3..."
    aws s3 cp $BACKUP_FILE $TEMP_DIR/
    BACKUP_FILE=$TEMP_DIR/$(basename $BACKUP_FILE)
fi

# Verify backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    log_error "Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Stop application
log_info "Stopping application..."
kubectl scale deployment rechain-dao-app --replicas=0 -n rechain-dao

# Wait for pods to terminate
kubectl wait --for=delete pod -l app=rechain-dao-app -n rechain-dao --timeout=300s

# Create database backup before restore
log_info "Creating database backup before restore..."
mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME > $TEMP_DIR/pre_restore_backup.sql

# Drop and recreate database
log_info "Dropping and recreating database..."
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "DROP DATABASE IF EXISTS $DB_NAME;"
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e "CREATE DATABASE $DB_NAME;"

# Restore database
log_info "Restoring database..."
if [[ $BACKUP_FILE == *.gz ]]; then
    gunzip -c $BACKUP_FILE | mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME
else
    mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < $BACKUP_FILE
fi

# Verify restore
log_info "Verifying restore..."
TABLE_COUNT=$(mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "SHOW TABLES;" | wc -l)
log_info "Restored $TABLE_COUNT tables"

# Start application
log_info "Starting application..."
kubectl scale deployment rechain-dao-app --replicas=3 -n rechain-dao

# Wait for application to be ready
kubectl wait --for=condition=ready pod -l app=rechain-dao-app -n rechain-dao --timeout=300s

# Cleanup
rm -rf $TEMP_DIR

log_success "Database restore completed successfully!"
```

### Full System Restore Script
```bash
#!/bin/bash
# full-restore.sh

set -e

# Configuration
BACKUP_DATE=$1
S3_BUCKET="rechain-dao-backups"
NAMESPACE="rechain-dao"

if [ -z "$BACKUP_DATE" ]; then
    echo "Usage: $0 <backup_date>"
    echo "Example: $0 20240101_120000"
    exit 1
fi

log_info "Starting full system restore from: $BACKUP_DATE"

# Confirm restore
read -p "Are you sure you want to restore the entire system? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Restore cancelled."
    exit 1
fi

# Download backups
log_info "Downloading backups from S3..."
mkdir -p /tmp/restore
aws s3 cp s3://$S3_BUCKET/mysql/mysql_full_$BACKUP_DATE.sql.gz /tmp/restore/
aws s3 cp s3://$S3_BUCKET/files/app_files_$BACKUP_DATE.tar.gz /tmp/restore/
aws s3 cp s3://$S3_BUCKET/config/all_config_$BACKUP_DATE.tar.gz /tmp/restore/
aws s3 cp s3://$S3_BUCKET/k8s/k8s_backup_$BACKUP_DATE.tar.gz /tmp/restore/

# Restore database
log_info "Restoring database..."
bash /opt/scripts/mysql-restore.sh /tmp/restore/mysql_full_$BACKUP_DATE.sql.gz

# Restore application files
log_info "Restoring application files..."
tar -xzf /tmp/restore/app_files_$BACKUP_DATE.tar.gz -C /var/www/rechain-dao/

# Restore configuration
log_info "Restoring configuration..."
tar -xzf /tmp/restore/all_config_$BACKUP_DATE.tar.gz -C /tmp/restore/
tar -xzf /tmp/restore/*.tar.gz -C /

# Restore Kubernetes resources
log_info "Restoring Kubernetes resources..."
tar -xzf /tmp/restore/k8s_backup_$BACKUP_DATE.tar.gz -C /tmp/restore/
kubectl apply -f /tmp/restore/k8s_resources_$BACKUP_DATE.yaml -n $NAMESPACE

# Cleanup
rm -rf /tmp/restore

log_success "Full system restore completed successfully!"
```

## Backup Validation

### Backup Validation Script
```bash
#!/bin/bash
# backup-validation.sh

set -e

# Configuration
BACKUP_DIR="/opt/backups"
S3_BUCKET="rechain-dao-backups"
VALIDATION_LOG="/var/log/backup-validation.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $VALIDATION_LOG
}

validate_mysql_backup() {
    local backup_file=$1
    log "Validating MySQL backup: $backup_file"
    
    # Check if file exists and is not empty
    if [ ! -s "$backup_file" ]; then
        log "ERROR: MySQL backup file is empty or missing"
        return 1
    fi
    
    # Check if file is compressed
    if [[ $backup_file == *.gz ]]; then
        # Test decompression
        if ! gunzip -t "$backup_file"; then
            log "ERROR: MySQL backup file is corrupted"
            return 1
        fi
    fi
    
    # Check for SQL content
    if [[ $backup_file == *.gz ]]; then
        if ! gunzip -c "$backup_file" | grep -q "CREATE TABLE"; then
            log "ERROR: MySQL backup file does not contain SQL content"
            return 1
        fi
    else
        if ! grep -q "CREATE TABLE" "$backup_file"; then
            log "ERROR: MySQL backup file does not contain SQL content"
            return 1
        fi
    fi
    
    log "MySQL backup validation passed"
    return 0
}

validate_file_backup() {
    local backup_file=$1
    log "Validating file backup: $backup_file"
    
    # Check if file exists and is not empty
    if [ ! -s "$backup_file" ]; then
        log "ERROR: File backup is empty or missing"
        return 1
    fi
    
    # Test tar extraction
    if ! tar -tzf "$backup_file" > /dev/null 2>&1; then
        log "ERROR: File backup is corrupted"
        return 1
    fi
    
    log "File backup validation passed"
    return 0
}

# Main validation
log "Starting backup validation..."

# Validate local backups
for backup in $BACKUP_DIR/mysql/mysql_full_*.sql.gz; do
    if [ -f "$backup" ]; then
        validate_mysql_backup "$backup"
    fi
done

for backup in $BACKUP_DIR/files/app_files_*.tar.gz; do
    if [ -f "$backup" ]; then
        validate_file_backup "$backup"
    fi
done

# Validate S3 backups
log "Validating S3 backups..."
aws s3 ls s3://$S3_BUCKET/mysql/ | while read -r line; do
    file=$(echo $line | awk '{print $4}')
    if [[ $file == mysql_full_*.sql.gz ]]; then
        log "Validating S3 MySQL backup: $file"
        aws s3 cp s3://$S3_BUCKET/mysql/$file /tmp/validation_$file
        validate_mysql_backup "/tmp/validation_$file"
        rm -f "/tmp/validation_$file"
    fi
done

log "Backup validation completed!"
```

## Conclusion

These backup scripts provide comprehensive backup and restore capabilities for the REChain DAO platform, ensuring data protection and disaster recovery. They include automated scheduling, validation, and monitoring to ensure backup reliability.

Remember: Regularly test restore procedures to ensure backups are working correctly. Monitor backup success rates and storage usage to maintain backup system health.
