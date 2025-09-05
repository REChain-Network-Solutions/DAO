# Deployment Scripts

## Overview

This document provides comprehensive deployment scripts for the REChain DAO platform, including automated deployment, rollback procedures, and environment management.

## Table of Contents

1. [Deployment Framework](#deployment-framework)
2. [Environment Setup](#environment-setup)
3. [Application Deployment](#application-deployment)
4. [Database Deployment](#database-deployment)
5. [Infrastructure Deployment](#infrastructure-deployment)
6. [Rollback Procedures](#rollback-procedures)
7. [Monitoring and Validation](#monitoring-and-validation)

## Deployment Framework

### Main Deployment Script
```bash
#!/bin/bash
# deploy.sh

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENVIRONMENT=${1:-staging}
VERSION=${2:-latest}
DRY_RUN=${3:-false}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validation functions
validate_environment() {
    local env=$1
    case $env in
        development|staging|production)
            return 0
            ;;
        *)
            log_error "Invalid environment: $env"
            log_info "Valid environments: development, staging, production"
            exit 1
            ;;
    esac
}

validate_prerequisites() {
    log_info "Validating prerequisites..."
    
    # Check required commands
    local required_commands=("kubectl" "docker" "helm" "git")
    for cmd in "${required_commands[@]}"; do
        if ! command -v $cmd &> /dev/null; then
            log_error "Required command not found: $cmd"
            exit 1
        fi
    done
    
    # Check Kubernetes connection
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Cannot connect to Kubernetes cluster"
        exit 1
    fi
    
    # Check Docker daemon
    if ! docker info &> /dev/null; then
        log_error "Docker daemon is not running"
        exit 1
    fi
    
    log_success "Prerequisites validated"
}

# Main deployment function
deploy() {
    local environment=$1
    local version=$2
    local dry_run=$3
    
    log_info "Starting deployment to $environment environment"
    log_info "Version: $version"
    log_info "Dry run: $dry_run"
    
    # Validate inputs
    validate_environment $environment
    validate_prerequisites
    
    # Load environment configuration
    load_environment_config $environment
    
    # Pre-deployment checks
    pre_deployment_checks $environment
    
    # Build and push images
    build_and_push_images $version $dry_run
    
    # Deploy infrastructure
    deploy_infrastructure $environment $dry_run
    
    # Deploy application
    deploy_application $environment $version $dry_run
    
    # Post-deployment validation
    post_deployment_validation $environment
    
    # Send notifications
    send_deployment_notification $environment $version "success"
    
    log_success "Deployment completed successfully!"
}

# Load environment configuration
load_environment_config() {
    local environment=$1
    local config_file="$SCRIPT_DIR/config/$environment.env"
    
    if [ ! -f "$config_file" ]; then
        log_error "Environment configuration file not found: $config_file"
        exit 1
    fi
    
    log_info "Loading environment configuration: $config_file"
    source "$config_file"
    
    # Set default values if not provided
    NAMESPACE=${NAMESPACE:-"rechain-dao-$environment"}
    REPLICAS=${REPLICAS:-3}
    RESOURCE_LIMITS_CPU=${RESOURCE_LIMITS_CPU:-"1000m"}
    RESOURCE_LIMITS_MEMORY=${RESOURCE_LIMITS_MEMORY:-"2Gi"}
    RESOURCE_REQUESTS_CPU=${RESOURCE_REQUESTS_CPU:-"500m"}
    RESOURCE_REQUESTS_MEMORY=${RESOURCE_REQUESTS_MEMORY:-"1Gi"}
    
    log_success "Environment configuration loaded"
}

# Pre-deployment checks
pre_deployment_checks() {
    local environment=$1
    
    log_info "Running pre-deployment checks..."
    
    # Check cluster resources
    check_cluster_resources
    
    # Check existing deployments
    check_existing_deployments $environment
    
    # Check database connectivity
    check_database_connectivity
    
    # Check external dependencies
    check_external_dependencies
    
    log_success "Pre-deployment checks completed"
}

# Check cluster resources
check_cluster_resources() {
    log_info "Checking cluster resources..."
    
    # Get cluster info
    local nodes=$(kubectl get nodes --no-headers | wc -l)
    local ready_nodes=$(kubectl get nodes --no-headers | grep "Ready" | wc -l)
    
    if [ $ready_nodes -lt $nodes ]; then
        log_warning "Not all nodes are ready ($ready_nodes/$nodes)"
    fi
    
    # Check resource usage
    local cpu_usage=$(kubectl top nodes --no-headers | awk '{sum+=$3} END {print sum/NR}')
    local memory_usage=$(kubectl top nodes --no-headers | awk '{sum+=$5} END {print sum/NR}')
    
    log_info "Average CPU usage: ${cpu_usage}%"
    log_info "Average memory usage: ${memory_usage}%"
    
    if (( $(echo "$cpu_usage > 80" | bc -l) )); then
        log_warning "High CPU usage detected: ${cpu_usage}%"
    fi
    
    if (( $(echo "$memory_usage > 80" | bc -l) )); then
        log_warning "High memory usage detected: ${memory_usage}%"
    fi
}

# Check existing deployments
check_existing_deployments() {
    local environment=$1
    local namespace="rechain-dao-$environment"
    
    log_info "Checking existing deployments in namespace: $namespace"
    
    # Check if namespace exists
    if ! kubectl get namespace $namespace &> /dev/null; then
        log_info "Namespace $namespace does not exist, will be created"
        return 0
    fi
    
    # Check existing deployments
    local deployments=$(kubectl get deployments -n $namespace --no-headers | wc -l)
    if [ $deployments -gt 0 ]; then
        log_info "Found $deployments existing deployments"
        
        # Check deployment status
        local failed_deployments=$(kubectl get deployments -n $namespace --no-headers | grep -v "1/1" | wc -l)
        if [ $failed_deployments -gt 0 ]; then
            log_warning "Found $failed_deployments deployments that are not ready"
        fi
    fi
}

# Check database connectivity
check_database_connectivity() {
    log_info "Checking database connectivity..."
    
    # Check if database pod is running
    local db_pod=$(kubectl get pods -n $NAMESPACE -l app=mysql --no-headers | head -1 | awk '{print $1}')
    
    if [ -z "$db_pod" ]; then
        log_warning "Database pod not found, will be created during deployment"
        return 0
    fi
    
    # Test database connection
    if kubectl exec -n $NAMESPACE $db_pod -- mysql -u$DB_USER -p$DB_PASSWORD -e "SELECT 1;" &> /dev/null; then
        log_success "Database connectivity verified"
    else
        log_error "Cannot connect to database"
        exit 1
    fi
}

# Check external dependencies
check_external_dependencies() {
    log_info "Checking external dependencies..."
    
    # Check external services
    local external_services=("api.rechain-dao.com" "rechain-dao.com")
    
    for service in "${external_services[@]}"; do
        if curl -f -s "https://$service/health" &> /dev/null; then
            log_success "External service $service is accessible"
        else
            log_warning "External service $service is not accessible"
        fi
    done
}

# Build and push images
build_and_push_images() {
    local version=$1
    local dry_run=$2
    
    log_info "Building and pushing Docker images..."
    
    # Build application image
    if [ "$dry_run" = "false" ]; then
        docker build -t $DOCKER_REGISTRY/rechain-dao:$version .
        docker push $DOCKER_REGISTRY/rechain-dao:$version
        log_success "Application image built and pushed: $DOCKER_REGISTRY/rechain-dao:$version"
    else
        log_info "Dry run: Would build and push image $DOCKER_REGISTRY/rechain-dao:$version"
    fi
}

# Deploy infrastructure
deploy_infrastructure() {
    local environment=$1
    local dry_run=$2
    
    log_info "Deploying infrastructure..."
    
    # Create namespace
    if [ "$dry_run" = "false" ]; then
        kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
        log_success "Namespace $NAMESPACE created/verified"
    else
        log_info "Dry run: Would create namespace $NAMESPACE"
    fi
    
    # Deploy database
    deploy_database $environment $dry_run
    
    # Deploy Redis
    deploy_redis $environment $dry_run
    
    # Deploy monitoring
    deploy_monitoring $environment $dry_run
    
    log_success "Infrastructure deployment completed"
}

# Deploy database
deploy_database() {
    local environment=$1
    local dry_run=$2
    
    log_info "Deploying database..."
    
    if [ "$dry_run" = "false" ]; then
        # Apply database manifests
        kubectl apply -f "$SCRIPT_DIR/k8s/database/" -n $NAMESPACE
        
        # Wait for database to be ready
        kubectl wait --for=condition=ready pod -l app=mysql -n $NAMESPACE --timeout=300s
        
        log_success "Database deployed successfully"
    else
        log_info "Dry run: Would deploy database"
    fi
}

# Deploy Redis
deploy_redis() {
    local environment=$1
    local dry_run=$2
    
    log_info "Deploying Redis..."
    
    if [ "$dry_run" = "false" ]; then
        # Apply Redis manifests
        kubectl apply -f "$SCRIPT_DIR/k8s/redis/" -n $NAMESPACE
        
        # Wait for Redis to be ready
        kubectl wait --for=condition=ready pod -l app=redis -n $NAMESPACE --timeout=300s
        
        log_success "Redis deployed successfully"
    else
        log_info "Dry run: Would deploy Redis"
    fi
}

# Deploy monitoring
deploy_monitoring() {
    local environment=$1
    local dry_run=$2
    
    log_info "Deploying monitoring..."
    
    if [ "$dry_run" = "false" ]; then
        # Deploy Prometheus
        helm upgrade --install prometheus prometheus-community/prometheus \
            --namespace $NAMESPACE \
            --values "$SCRIPT_DIR/helm/prometheus/values-$environment.yaml"
        
        # Deploy Grafana
        helm upgrade --install grafana grafana/grafana \
            --namespace $NAMESPACE \
            --values "$SCRIPT_DIR/helm/grafana/values-$environment.yaml"
        
        log_success "Monitoring deployed successfully"
    else
        log_info "Dry run: Would deploy monitoring"
    fi
}

# Deploy application
deploy_application() {
    local environment=$1
    local version=$2
    local dry_run=$3
    
    log_info "Deploying application..."
    
    if [ "$dry_run" = "false" ]; then
        # Update image version in manifests
        sed -i "s|image: .*|image: $DOCKER_REGISTRY/rechain-dao:$version|g" "$SCRIPT_DIR/k8s/application/deployment.yaml"
        
        # Apply application manifests
        kubectl apply -f "$SCRIPT_DIR/k8s/application/" -n $NAMESPACE
        
        # Wait for deployment to be ready
        kubectl rollout status deployment/rechain-dao-app -n $NAMESPACE --timeout=600s
        
        log_success "Application deployed successfully"
    else
        log_info "Dry run: Would deploy application with version $version"
    fi
}

# Post-deployment validation
post_deployment_validation() {
    local environment=$1
    
    log_info "Running post-deployment validation..."
    
    # Check pod status
    check_pod_status
    
    # Check service endpoints
    check_service_endpoints
    
    # Check application health
    check_application_health
    
    # Run smoke tests
    run_smoke_tests $environment
    
    log_success "Post-deployment validation completed"
}

# Check pod status
check_pod_status() {
    log_info "Checking pod status..."
    
    local pods=$(kubectl get pods -n $NAMESPACE --no-headers | wc -l)
    local ready_pods=$(kubectl get pods -n $NAMESPACE --no-headers | grep "Running" | wc -l)
    
    if [ $ready_pods -eq $pods ]; then
        log_success "All pods are running ($ready_pods/$pods)"
    else
        log_error "Not all pods are running ($ready_pods/$pods)"
        kubectl get pods -n $NAMESPACE
        exit 1
    fi
}

# Check service endpoints
check_service_endpoints() {
    log_info "Checking service endpoints..."
    
    local services=("rechain-dao-app" "mysql" "redis")
    
    for service in "${services[@]}"; do
        local endpoints=$(kubectl get endpoints $service -n $NAMESPACE --no-headers | awk '{print $2}')
        if [ "$endpoints" != "<none>" ] && [ -n "$endpoints" ]; then
            log_success "Service $service has endpoints: $endpoints"
        else
            log_error "Service $service has no endpoints"
            exit 1
        fi
    done
}

# Check application health
check_application_health() {
    log_info "Checking application health..."
    
    local app_pod=$(kubectl get pods -n $NAMESPACE -l app=rechain-dao-app --no-headers | head -1 | awk '{print $1}')
    
    if [ -z "$app_pod" ]; then
        log_error "Application pod not found"
        exit 1
    fi
    
    # Check health endpoint
    if kubectl exec -n $NAMESPACE $app_pod -- curl -f http://localhost:8000/health &> /dev/null; then
        log_success "Application health check passed"
    else
        log_error "Application health check failed"
        exit 1
    fi
}

# Run smoke tests
run_smoke_tests() {
    local environment=$1
    
    log_info "Running smoke tests..."
    
    # Get application URL
    local app_url=$(kubectl get service rechain-dao-app -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if [ -z "$app_url" ]; then
        app_url="localhost"
    fi
    
    # Test basic endpoints
    local endpoints=("/health" "/api/status" "/api/version")
    
    for endpoint in "${endpoints[@]}"; do
        if curl -f -s "http://$app_url$endpoint" &> /dev/null; then
            log_success "Smoke test passed: $endpoint"
        else
            log_error "Smoke test failed: $endpoint"
            exit 1
        fi
    done
}

# Send deployment notification
send_deployment_notification() {
    local environment=$1
    local version=$2
    local status=$3
    
    log_info "Sending deployment notification..."
    
    # Send to Slack
    if [ -n "$SLACK_WEBHOOK_URL" ]; then
        local message="Deployment to $environment environment $status\nVersion: $version\nTime: $(date)"
        curl -X POST -H 'Content-type: application/json' \
            --data "{\"text\":\"$message\"}" \
            $SLACK_WEBHOOK_URL
    fi
    
    # Send email
    if [ -n "$NOTIFICATION_EMAIL" ]; then
        echo "Deployment to $environment environment $status\nVersion: $version\nTime: $(date)" | \
            mail -s "Deployment $status - $environment" $NOTIFICATION_EMAIL
    fi
    
    log_success "Deployment notification sent"
}

# Main execution
main() {
    case "${1:-}" in
        deploy)
            deploy $2 $3 $4
            ;;
        rollback)
            rollback $2 $3
            ;;
        status)
            status $2
            ;;
        *)
            echo "Usage: $0 {deploy|rollback|status} [environment] [version] [dry-run]"
            echo "Examples:"
            echo "  $0 deploy staging v1.2.3"
            echo "  $0 deploy production latest false"
            echo "  $0 rollback staging v1.2.2"
            echo "  $0 status production"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
```

## Environment Setup

### Environment Configuration
```bash
#!/bin/bash
# setup-environment.sh

set -e

# Configuration
ENVIRONMENT=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <environment>"
    echo "Example: $0 staging"
    exit 1
fi

echo "Setting up $ENVIRONMENT environment..."

# Create environment directory
mkdir -p "$SCRIPT_DIR/environments/$ENVIRONMENT"

# Create environment configuration
cat > "$SCRIPT_DIR/environments/$ENVIRONMENT/config.env" << EOF
# Environment: $ENVIRONMENT
# Generated: $(date)

# Kubernetes Configuration
NAMESPACE="rechain-dao-$ENVIRONMENT"
REPLICAS=3

# Resource Configuration
RESOURCE_LIMITS_CPU="1000m"
RESOURCE_LIMITS_MEMORY="2Gi"
RESOURCE_REQUESTS_CPU="500m"
RESOURCE_REQUESTS_MEMORY="1Gi"

# Database Configuration
DB_HOST="mysql-service"
DB_PORT="3306"
DB_NAME="rechain_dao"
DB_USER="rechain"
DB_PASSWORD=""

# Redis Configuration
REDIS_HOST="redis-service"
REDIS_PORT="6379"
REDIS_PASSWORD=""

# Docker Configuration
DOCKER_REGISTRY="your-registry.com"
DOCKER_NAMESPACE="rechain-dao"

# Monitoring Configuration
PROMETHEUS_ENABLED=true
GRAFANA_ENABLED=true
ALERTMANAGER_ENABLED=true

# External Services
EXTERNAL_API_URL="https://api.rechain-dao.com"
EXTERNAL_WEB_URL="https://rechain-dao.com"

# Notifications
SLACK_WEBHOOK_URL=""
NOTIFICATION_EMAIL="admin@rechain-dao.com"
EOF

# Create Kubernetes manifests
mkdir -p "$SCRIPT_DIR/environments/$ENVIRONMENT/k8s"

# Create namespace manifest
cat > "$SCRIPT_DIR/environments/$ENVIRONMENT/k8s/namespace.yaml" << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: rechain-dao-$ENVIRONMENT
  labels:
    name: rechain-dao-$ENVIRONMENT
    environment: $ENVIRONMENT
EOF

# Create ConfigMap manifest
cat > "$SCRIPT_DIR/environments/$ENVIRONMENT/k8s/configmap.yaml" << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: rechain-dao-config
  namespace: rechain-dao-$ENVIRONMENT
data:
  NODE_ENV: "$ENVIRONMENT"
  PORT: "8000"
  LOG_LEVEL: "info"
  DB_HOST: "mysql-service"
  DB_PORT: "3306"
  DB_NAME: "rechain_dao"
  REDIS_HOST: "redis-service"
  REDIS_PORT: "6379"
EOF

# Create Secret manifest
cat > "$SCRIPT_DIR/environments/$ENVIRONMENT/k8s/secret.yaml" << EOF
apiVersion: v1
kind: Secret
metadata:
  name: rechain-dao-secrets
  namespace: rechain-dao-$ENVIRONMENT
type: Opaque
data:
  # Base64 encoded values - replace with actual values
  DB_PASSWORD: ""
  REDIS_PASSWORD: ""
  JWT_SECRET: ""
EOF

# Create Helm values
mkdir -p "$SCRIPT_DIR/environments/$ENVIRONMENT/helm"

# Create Prometheus values
cat > "$SCRIPT_DIR/environments/$ENVIRONMENT/helm/prometheus-values.yaml" << EOF
# Prometheus configuration for $ENVIRONMENT environment

server:
  persistentVolume:
    enabled: true
    size: 10Gi
  
  resources:
    limits:
      cpu: 1000m
      memory: 2Gi
    requests:
      cpu: 500m
      memory: 1Gi

alertmanager:
  enabled: true
  persistentVolume:
    enabled: true
    size: 5Gi

pushgateway:
  enabled: true
  persistentVolume:
    enabled: true
    size: 2Gi
EOF

# Create Grafana values
cat > "$SCRIPT_DIR/environments/$ENVIRONMENT/helm/grafana-values.yaml" << EOF
# Grafana configuration for $ENVIRONMENT environment

adminPassword: "admin"

persistence:
  enabled: true
  size: 5Gi

resources:
  limits:
    cpu: 500m
    memory: 1Gi
  requests:
    cpu: 250m
    memory: 512Mi

service:
  type: LoadBalancer
  port: 3000
EOF

echo "Environment $ENVIRONMENT setup completed!"
echo "Configuration files created in: $SCRIPT_DIR/environments/$ENVIRONMENT/"
echo ""
echo "Next steps:"
echo "1. Update the configuration files with actual values"
echo "2. Create secrets with actual values"
echo "3. Run deployment: ./deploy.sh deploy $ENVIRONMENT"
```

## Rollback Procedures

### Rollback Script
```bash
#!/bin/bash
# rollback.sh

set -e

# Configuration
ENVIRONMENT=$1
VERSION=$2
NAMESPACE="rechain-dao-$ENVIRONMENT"

if [ -z "$ENVIRONMENT" ] || [ -z "$VERSION" ]; then
    echo "Usage: $0 <environment> <version>"
    echo "Example: $0 staging v1.2.2"
    exit 1
fi

echo "Rolling back $ENVIRONMENT environment to version $VERSION..."

# Check if deployment exists
if ! kubectl get deployment rechain-dao-app -n $NAMESPACE &> /dev/null; then
    echo "Error: Deployment not found in namespace $NAMESPACE"
    exit 1
fi

# Check if target version exists
if ! kubectl get deployment rechain-dao-app -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].image}' | grep -q "$VERSION"; then
    echo "Error: Version $VERSION not found in deployment history"
    echo "Available versions:"
    kubectl rollout history deployment/rechain-dao-app -n $NAMESPACE
    exit 1
fi

# Confirm rollback
read -p "Are you sure you want to rollback to version $VERSION? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Rollback cancelled."
    exit 1
fi

# Perform rollback
echo "Rolling back deployment..."
kubectl rollout undo deployment/rechain-dao-app -n $NAMESPACE --to-revision=$VERSION

# Wait for rollback to complete
echo "Waiting for rollback to complete..."
kubectl rollout status deployment/rechain-dao-app -n $NAMESPACE --timeout=600s

# Verify rollback
echo "Verifying rollback..."
kubectl get pods -n $NAMESPACE -l app=rechain-dao-app

# Check application health
echo "Checking application health..."
kubectl exec -n $NAMESPACE $(kubectl get pods -n $NAMESPACE -l app=rechain-dao-app --no-headers | head -1 | awk '{print $1}') -- curl -f http://localhost:8000/health

echo "Rollback completed successfully!"
echo "Current version: $(kubectl get deployment rechain-dao-app -n $NAMESPACE -o jsonpath='{.spec.template.spec.containers[0].image}')"
```

## Monitoring and Validation

### Health Check Script
```bash
#!/bin/bash
# health-check.sh

set -e

# Configuration
ENVIRONMENT=$1
NAMESPACE="rechain-dao-$ENVIRONMENT"

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <environment>"
    echo "Example: $0 staging"
    exit 1
fi

echo "Running health check for $ENVIRONMENT environment..."

# Check namespace
if ! kubectl get namespace $NAMESPACE &> /dev/null; then
    echo "Error: Namespace $NAMESPACE not found"
    exit 1
fi

# Check pods
echo "Checking pods..."
kubectl get pods -n $NAMESPACE

# Check services
echo "Checking services..."
kubectl get services -n $NAMESPACE

# Check deployments
echo "Checking deployments..."
kubectl get deployments -n $NAMESPACE

# Check ingress
echo "Checking ingress..."
kubectl get ingress -n $NAMESPACE

# Check resource usage
echo "Checking resource usage..."
kubectl top pods -n $NAMESPACE

# Check logs for errors
echo "Checking logs for errors..."
kubectl logs -n $NAMESPACE -l app=rechain-dao-app --tail=100 | grep -i error || echo "No errors found in logs"

# Check application health endpoint
echo "Checking application health..."
kubectl exec -n $NAMESPACE $(kubectl get pods -n $NAMESPACE -l app=rechain-dao-app --no-headers | head -1 | awk '{print $1}') -- curl -f http://localhost:8000/health

echo "Health check completed!"
```

## Conclusion

These deployment scripts provide a comprehensive framework for deploying the REChain DAO platform across different environments, including automated deployment, rollback procedures, and health monitoring. They ensure reliable and consistent deployments with proper validation and error handling.

Remember: Always test deployment scripts in a staging environment before using them in production. Regularly update and maintain the scripts to reflect changes in the application and infrastructure requirements.
