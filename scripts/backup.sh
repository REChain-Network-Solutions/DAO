#!/bin/bash

# REChain DAO Platform Backup Script
# This script creates comprehensive backups of the platform

set -euo pipefail

# Configuration
BACKUP_DIR="/opt/backups/rechain-dao"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="rechain-dao-backup-${DATE}"
RETENTION_DAYS=30
LOG_FILE="/var/log/rechain-dao/backup.log"

# Database configuration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-rechain_dao}"
DB_USER="${DB_USER:-rechain_user}"
DB_PASSWORD="${DB_PASSWORD:-}"

# Redis configuration
REDIS_HOST="${REDIS_HOST:-localhost}"
REDIS_PORT="${REDIS_PORT:-6379}"
REDIS_PASSWORD="${REDIS_PASSWORD:-}"

# Application configuration
APP_DIR="${APP_DIR:-/opt/rechain-dao}"
CONFIG_DIR="${CONFIG_DIR:-/etc/rechain-dao}"
LOG_DIR="${LOG_DIR:-/var/log/rechain-dao}"

# Create backup directory
mkdir -p "${BACKUP_DIR}/${BACKUP_NAME}"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

# Error handling
error_exit() {
    log "ERROR: $1"
    exit 1
}

# Check if required tools are installed
check_dependencies() {
    log "Checking dependencies..."
    
    command -v mysqldump >/dev/null 2>&1 || error_exit "mysqldump is required but not installed"
    command -v redis-cli >/dev/null 2>&1 || error_exit "redis-cli is required but not installed"
    command -v tar >/dev/null 2>&1 || error_exit "tar is required but not installed"
    command -v gzip >/dev/null 2>&1 || error_exit "gzip is required but not installed"
    
    log "All dependencies are available"
}

# Create database backup
backup_database() {
    log "Creating database backup..."
    
    local db_backup_file="${BACKUP_DIR}/${BACKUP_NAME}/database.sql"
    
    if [ -n "${DB_PASSWORD}" ]; then
        mysqldump -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" -p"${DB_PASSWORD}" \
            --single-transaction --routines --triggers --events \
            "${DB_NAME}" > "${db_backup_file}" 2>/dev/null
    else
        mysqldump -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" \
            --single-transaction --routines --triggers --events \
            "${DB_NAME}" > "${db_backup_file}" 2>/dev/null
    fi
    
    if [ $? -eq 0 ]; then
        log "Database backup completed: ${db_backup_file}"
        gzip "${db_backup_file}"
        log "Database backup compressed: ${db_backup_file}.gz"
    else
        error_exit "Database backup failed"
    fi
}

# Create Redis backup
backup_redis() {
    log "Creating Redis backup..."
    
    local redis_backup_file="${BACKUP_DIR}/${BACKUP_NAME}/redis.rdb"
    
    if [ -n "${REDIS_PASSWORD}" ]; then
        redis-cli -h "${REDIS_HOST}" -p "${REDIS_PORT}" -a "${REDIS_PASSWORD}" \
            --rdb "${redis_backup_file}" >/dev/null 2>&1
    else
        redis-cli -h "${REDIS_HOST}" -p "${REDIS_PORT}" \
            --rdb "${redis_backup_file}" >/dev/null 2>&1
    fi
    
    if [ $? -eq 0 ]; then
        log "Redis backup completed: ${redis_backup_file}"
        gzip "${redis_backup_file}"
        log "Redis backup compressed: ${redis_backup_file}.gz"
    else
        log "WARNING: Redis backup failed or Redis is not running"
    fi
}

# Create application files backup
backup_application() {
    log "Creating application files backup..."
    
    local app_backup_file="${BACKUP_DIR}/${BACKUP_NAME}/application.tar.gz"
    
    tar -czf "${app_backup_file}" \
        -C "${APP_DIR}" \
        --exclude="node_modules" \
        --exclude="dist" \
        --exclude=".git" \
        --exclude="*.log" \
        . 2>/dev/null
    
    if [ $? -eq 0 ]; then
        log "Application files backup completed: ${app_backup_file}"
    else
        error_exit "Application files backup failed"
    fi
}

# Create configuration backup
backup_configuration() {
    log "Creating configuration backup..."
    
    local config_backup_file="${BACKUP_DIR}/${BACKUP_NAME}/configuration.tar.gz"
    
    tar -czf "${config_backup_file}" \
        -C "${CONFIG_DIR}" \
        . 2>/dev/null
    
    if [ $? -eq 0 ]; then
        log "Configuration backup completed: ${config_backup_file}"
    else
        log "WARNING: Configuration backup failed or directory does not exist"
    fi
}

# Create logs backup
backup_logs() {
    log "Creating logs backup..."
    
    local logs_backup_file="${BACKUP_DIR}/${BACKUP_NAME}/logs.tar.gz"
    
    if [ -d "${LOG_DIR}" ]; then
        tar -czf "${logs_backup_file}" \
            -C "${LOG_DIR}" \
            . 2>/dev/null
        
        if [ $? -eq 0 ]; then
            log "Logs backup completed: ${logs_backup_file}"
        else
            log "WARNING: Logs backup failed"
        fi
    else
        log "WARNING: Logs directory does not exist: ${LOG_DIR}"
    fi
}

# Create Docker volumes backup
backup_docker_volumes() {
    log "Creating Docker volumes backup..."
    
    local docker_backup_file="${BACKUP_DIR}/${BACKUP_NAME}/docker-volumes.tar.gz"
    
    # Get list of Docker volumes
    local volumes=$(docker volume ls -q | grep rechain-dao || true)
    
    if [ -n "${volumes}" ]; then
        docker run --rm \
            -v /var/lib/docker/volumes:/backup \
            -v "${BACKUP_DIR}/${BACKUP_NAME}:/output" \
            alpine:latest \
            tar -czf "/output/docker-volumes.tar.gz" \
            -C /backup \
            $(echo "${volumes}" | tr '\n' ' ') 2>/dev/null
        
        if [ $? -eq 0 ]; then
            log "Docker volumes backup completed: ${docker_backup_file}"
        else
            log "WARNING: Docker volumes backup failed"
        fi
    else
        log "WARNING: No Docker volumes found for rechain-dao"
    fi
}

# Create Kubernetes resources backup
backup_kubernetes() {
    log "Creating Kubernetes resources backup..."
    
    local k8s_backup_file="${BACKUP_DIR}/${BACKUP_NAME}/kubernetes-resources.yaml"
    
    if command -v kubectl >/dev/null 2>&1; then
        kubectl get all -o yaml > "${k8s_backup_file}" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            log "Kubernetes resources backup completed: ${k8s_backup_file}"
            gzip "${k8s_backup_file}"
            log "Kubernetes resources backup compressed: ${k8s_backup_file}.gz"
        else
            log "WARNING: Kubernetes resources backup failed or kubectl not configured"
        fi
    else
        log "WARNING: kubectl not found, skipping Kubernetes backup"
    fi
}

# Create backup manifest
create_manifest() {
    log "Creating backup manifest..."
    
    local manifest_file="${BACKUP_DIR}/${BACKUP_NAME}/backup-manifest.txt"
    
    cat > "${manifest_file}" << EOF
REChain DAO Platform Backup Manifest
====================================

Backup Date: $(date)
Backup Name: ${BACKUP_NAME}
Backup Directory: ${BACKUP_DIR}/${BACKUP_NAME}

Components Backed Up:
- Database: ${DB_NAME}@${DB_HOST}:${DB_PORT}
- Redis: ${REDIS_HOST}:${REDIS_PORT}
- Application: ${APP_DIR}
- Configuration: ${CONFIG_DIR}
- Logs: ${LOG_DIR}
- Docker Volumes: $(docker volume ls -q | grep rechain-dao | wc -l) volumes
- Kubernetes Resources: $(kubectl get all 2>/dev/null | wc -l || echo "N/A") resources

Backup Files:
$(ls -la "${BACKUP_DIR}/${BACKUP_NAME}")

Total Size: $(du -sh "${BACKUP_DIR}/${BACKUP_NAME}" | cut -f1)

Backup completed successfully!
EOF
    
    log "Backup manifest created: ${manifest_file}"
}

# Cleanup old backups
cleanup_old_backups() {
    log "Cleaning up old backups (older than ${RETENTION_DAYS} days)..."
    
    find "${BACKUP_DIR}" -type d -name "rechain-dao-backup-*" -mtime +${RETENTION_DAYS} -exec rm -rf {} \; 2>/dev/null || true
    
    log "Old backups cleanup completed"
}

# Verify backup integrity
verify_backup() {
    log "Verifying backup integrity..."
    
    local backup_path="${BACKUP_DIR}/${BACKUP_NAME}"
    local verification_failed=false
    
    # Check if backup directory exists
    if [ ! -d "${backup_path}" ]; then
        error_exit "Backup directory does not exist: ${backup_path}"
    fi
    
    # Check if essential files exist
    local essential_files=(
        "database.sql.gz"
        "application.tar.gz"
        "backup-manifest.txt"
    )
    
    for file in "${essential_files[@]}"; do
        if [ ! -f "${backup_path}/${file}" ]; then
            log "WARNING: Essential file missing: ${file}"
            verification_failed=true
        fi
    done
    
    if [ "${verification_failed}" = true ]; then
        log "WARNING: Backup verification failed - some files are missing"
    else
        log "Backup verification completed successfully"
    fi
}

# Send backup notification
send_notification() {
    local status="$1"
    local message="$2"
    
    if [ -n "${BACKUP_NOTIFICATION_WEBHOOK:-}" ]; then
        curl -X POST "${BACKUP_NOTIFICATION_WEBHOOK}" \
            -H "Content-Type: application/json" \
            -d "{\"text\":\"REChain DAO Backup ${status}: ${message}\"}" \
            2>/dev/null || true
    fi
    
    if [ -n "${BACKUP_NOTIFICATION_EMAIL:-}" ]; then
        echo "${message}" | mail -s "REChain DAO Backup ${status}" "${BACKUP_NOTIFICATION_EMAIL}" 2>/dev/null || true
    fi
}

# Main backup function
main() {
    log "Starting REChain DAO Platform backup process..."
    
    # Check dependencies
    check_dependencies
    
    # Create backups
    backup_database
    backup_redis
    backup_application
    backup_configuration
    backup_logs
    backup_docker_volumes
    backup_kubernetes
    
    # Create manifest
    create_manifest
    
    # Verify backup
    verify_backup
    
    # Cleanup old backups
    cleanup_old_backups
    
    log "Backup process completed successfully!"
    
    # Send success notification
    send_notification "SUCCESS" "Backup completed successfully: ${BACKUP_NAME}"
    
    exit 0
}

# Error handler
trap 'log "ERROR: Backup process failed at line $LINENO"; send_notification "FAILED" "Backup process failed at line $LINENO"; exit 1' ERR

# Run main function
main "$@"