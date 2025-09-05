#!/bin/bash

# REChain DAO Platform Deployment Script
set -euo pipefail

# Configuration
APP_NAME="rechain-dao"
APP_USER="rechain"
APP_GROUP="rechain"
APP_HOME="/opt/rechain-dao"
APP_PORT=3000
DOCKER_REGISTRY="${DOCKER_REGISTRY:-your-registry.com}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
ENVIRONMENT="${ENVIRONMENT:-production}"
LOG_FILE="/var/log/rechain-dao/deploy.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "${LOG_FILE}"
}

# Error handling
error_exit() {
    echo -e "${RED}ERROR: $1${NC}" | tee -a "${LOG_FILE}"
    exit 1
}

# Success message
success() {
    echo -e "${GREEN}SUCCESS: $1${NC}" | tee -a "${LOG_FILE}"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        error_exit "This script must be run as root"
    fi
}

# Install required packages
install_packages() {
    log "Installing required packages..."
    
    if command -v apt-get >/dev/null 2>&1; then
        apt-get update
        apt-get install -y curl wget git unzip software-properties-common
    elif command -v yum >/dev/null 2>&1; then
        yum update -y
        yum install -y curl wget git unzip
    else
        error_exit "Unsupported package manager"
    fi
    
    success "Required packages installed"
}

# Install Docker
install_docker() {
    log "Installing Docker..."
    
    if command -v docker >/dev/null 2>&1; then
        log "Docker is already installed"
        return
    fi
    
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    
    systemctl start docker
    systemctl enable docker
    
    success "Docker installed and configured"
}

# Install Docker Compose
install_docker_compose() {
    log "Installing Docker Compose..."
    
    if command -v docker-compose >/dev/null 2>&1; then
        log "Docker Compose is already installed"
        return
    fi
    
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    
    success "Docker Compose installed"
}

# Create application user
create_user() {
    log "Creating application user..."
    
    if id "${APP_USER}" >/dev/null 2>&1; then
        log "User ${APP_USER} already exists"
    else
        useradd -r -s /bin/bash -d "${APP_HOME}" -m "${APP_USER}"
        usermod -aG docker "${APP_USER}"
    fi
    
    success "Application user created"
}

# Create application directories
create_directories() {
    log "Creating application directories..."
    
    local dirs=(
        "${APP_HOME}"
        "${APP_HOME}/logs"
        "${APP_HOME}/data"
        "${APP_HOME}/config"
        "${APP_HOME}/backups"
        "${APP_HOME}/scripts"
        "${APP_HOME}/monitoring"
        "${APP_HOME}/nginx"
        "${APP_HOME}/ssl"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "${dir}"
        chown "${APP_USER}:${APP_GROUP}" "${dir}"
        chmod 755 "${dir}"
    done
    
    success "Application directories created"
}

# Create environment file
create_env_file() {
    log "Creating environment file..."
    
    cat > "${APP_HOME}/.env" << EOF
NODE_ENV=${ENVIRONMENT}
APP_NAME=${APP_NAME}
APP_PORT=${APP_PORT}
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-3306}
DB_NAME=${DB_NAME:-rechain_dao}
DB_USER=${DB_USER:-rechain_user}
DB_PASSWORD=${DB_PASSWORD:-}
REDIS_HOST=${REDIS_HOST:-localhost}
REDIS_PORT=${REDIS_PORT:-6379}
REDIS_PASSWORD=${REDIS_PASSWORD:-}
JWT_SECRET=${JWT_SECRET:-}
CORS_ORIGIN=${CORS_ORIGIN:-*}
LOG_LEVEL=${LOG_LEVEL:-info}
DOCKER_REGISTRY=${DOCKER_REGISTRY}
IMAGE_TAG=${IMAGE_TAG}
EOF
    
    chown "${APP_USER}:${APP_GROUP}" "${APP_HOME}/.env"
    chmod 600 "${APP_HOME}/.env"
    
    success "Environment file created"
}

# Deploy application
deploy_application() {
    log "Deploying application..."
    
    # Copy docker-compose file
    cp docker-compose.prod.yml "${APP_HOME}/docker-compose.yml"
    chown "${APP_USER}:${APP_GROUP}" "${APP_HOME}/docker-compose.yml"
    
    # Start services
    log "Starting services..."
    sudo -u "${APP_USER}" docker-compose -f "${APP_HOME}/docker-compose.yml" up -d
    
    # Wait for services to start
    log "Waiting for services to start..."
    sleep 30
    
    # Check health
    log "Checking application health..."
    local max_attempts=30
    local attempt=1
    
    while [ ${attempt} -le ${max_attempts} ]; do
        if curl -f "http://localhost:${APP_PORT}/health" >/dev/null 2>&1; then
            success "Application is healthy"
            break
        else
            log "Health check attempt ${attempt}/${max_attempts} failed"
            sleep 10
            attempt=$((attempt + 1))
        fi
    done
    
    if [ ${attempt} -gt ${max_attempts} ]; then
        error_exit "Application failed to start after ${max_attempts} attempts"
    fi
}

# Main deployment function
main() {
    log "Starting REChain DAO Platform deployment..."
    
    check_root
    install_packages
    install_docker
    install_docker_compose
    create_user
    create_directories
    create_env_file
    deploy_application
    
    success "REChain DAO Platform deployed successfully!"
}

# Run main function
main "$@"