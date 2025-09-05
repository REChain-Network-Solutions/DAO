#!/bin/bash

# REChain DAO Platform Migration Script
set -e

# Configuration
MIGRATION_TYPE=${1:-all}
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

# Error function
error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
    exit 1
}

# Success function
success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Warning function
warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    # Check if Node.js is installed
    if ! command -v node &> /dev/null; then
        error "Node.js is not installed"
    fi
    
    # Check if MySQL is installed
    if ! command -v mysql &> /dev/null; then
        error "MySQL is not installed"
    fi
    
    # Check if npm is installed
    if ! command -v npm &> /dev/null; then
        error "npm is not installed"
    fi
    
    # Check if dependencies are installed
    if [ ! -d "node_modules" ]; then
        log "Installing dependencies..."
        npm install
    fi
    
    success "Prerequisites check passed"
}

# Create backup
create_backup() {
    log "Creating backup..."
    
    # Create backup directory
    mkdir -p $BACKUP_DIR
    
    # Database backup
    log "Backing up database..."
    mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_DIR/database_backup_$TIMESTAMP.sql
    
    # Files backup
    log "Backing up files..."
    tar -czf $BACKUP_DIR/files_backup_$TIMESTAMP.tar.gz uploads/ logs/ 2>/dev/null || true
    
    # Configuration backup
    log "Backing up configuration..."
    cp .env $BACKUP_DIR/env_backup_$TIMESTAMP.txt
    cp package.json $BACKUP_DIR/package_backup_$TIMESTAMP.json
    
    success "Backup created: $BACKUP_DIR/backup_$TIMESTAMP"
}

# Run database migrations
run_database_migrations() {
    log "Running database migrations..."
    
    # Check if migrations exist
    if [ ! -d "migrations" ]; then
        warning "No migrations directory found"
        return 0
    fi
    
    # Run migrations
    npm run db:migrate
    
    success "Database migrations completed"
}

# Run data migrations
run_data_migrations() {
    log "Running data migrations..."
    
    # Check if data migrations exist
    if [ ! -d "data-migrations" ]; then
        warning "No data migrations directory found"
        return 0
    fi
    
    # Run data migrations
    for file in data-migrations/*.js; do
        if [ -f "$file" ]; then
            log "Running data migration: $file"
            node "$file"
        fi
    done
    
    success "Data migrations completed"
}

# Run index migrations
run_index_migrations() {
    log "Running index migrations..."
    
    # Check if index migrations exist
    if [ ! -d "index-migrations" ]; then
        warning "No index migrations directory found"
        return 0
    fi
    
    # Run index migrations
    for file in index-migrations/*.sql; do
        if [ -f "$file" ]; then
            log "Running index migration: $file"
            mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < "$file"
        fi
    done
    
    success "Index migrations completed"
}

# Verify migration
verify_migration() {
    log "Verifying migration..."
    
    # Check database connection
    mysql -u $DB_USER -p$DB_PASSWORD -e "SELECT 1;" $DB_NAME > /dev/null
    
    # Check if tables exist
    TABLES=$(mysql -u $DB_USER -p$DB_PASSWORD -e "SHOW TABLES;" $DB_NAME | wc -l)
    
    if [ $TABLES -gt 1 ]; then
        success "Migration verification passed ($TABLES tables found)"
    else
        error "Migration verification failed (no tables found)"
    fi
}

# Rollback migration
rollback_migration() {
    log "Rolling back migration..."
    
    # Check if rollback is available
    if [ ! -f "$BACKUP_DIR/database_backup_$TIMESTAMP.sql" ]; then
        error "No backup found for rollback"
    fi
    
    # Restore database
    mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < $BACKUP_DIR/database_backup_$TIMESTAMP.sql
    
    # Restore files
    if [ -f "$BACKUP_DIR/files_backup_$TIMESTAMP.tar.gz" ]; then
        tar -xzf $BACKUP_DIR/files_backup_$TIMESTAMP.tar.gz
    fi
    
    success "Migration rollback completed"
}

# Cleanup old backups
cleanup_backups() {
    log "Cleaning up old backups..."
    
    # Keep only last 7 days of backups
    find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
    find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
    find $BACKUP_DIR -name "*.txt" -mtime +7 -delete
    find $BACKUP_DIR -name "*.json" -mtime +7 -delete
    
    success "Old backups cleaned up"
}

# Main migration function
main() {
    log "Starting migration process..."
    
    # Check prerequisites
    check_prerequisites
    
    # Create backup
    create_backup
    
    # Run migrations based on type
    case $MIGRATION_TYPE in
        "database")
            run_database_migrations
            ;;
        "data")
            run_data_migrations
            ;;
        "index")
            run_index_migrations
            ;;
        "all")
            run_database_migrations
            run_data_migrations
            run_index_migrations
            ;;
        *)
            error "Invalid migration type: $MIGRATION_TYPE"
            ;;
    esac
    
    # Verify migration
    verify_migration
    
    # Cleanup old backups
    cleanup_backups
    
    success "Migration completed successfully!"
}

# Handle script arguments
case "${1:-}" in
    "rollback")
        rollback_migration
        ;;
    "verify")
        verify_migration
        ;;
    "cleanup")
        cleanup_backups
        ;;
    *)
        main
        ;;
esac
