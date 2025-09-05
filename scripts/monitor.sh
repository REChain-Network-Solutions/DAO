#!/bin/bash

# REChain DAO Platform Monitoring Script
# This script monitors system health and application status

set -euo pipefail

# Configuration
LOG_FILE="/var/log/rechain-dao/monitor.log"
ALERT_EMAIL="${ALERT_EMAIL:-admin@rechain-dao.com}"
ALERT_WEBHOOK="${ALERT_WEBHOOK:-}"
CHECK_INTERVAL="${CHECK_INTERVAL:-60}"
MAX_RETRIES=3

# Application configuration
APP_HOST="${APP_HOST:-localhost}"
APP_PORT="${APP_PORT:-3000}"
APP_HEALTH_ENDPOINT="/health"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
REDIS_HOST="${REDIS_HOST:-localhost}"
REDIS_PORT="${REDIS_PORT:-6379}"

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=85
DISK_THRESHOLD=90
RESPONSE_TIME_THRESHOLD=2000
ERROR_RATE_THRESHOLD=5

# Alert states
declare -A ALERT_STATES
ALERT_STATES[app_down]=false
ALERT_STATES[db_down]=false
ALERT_STATES[redis_down]=false
ALERT_STATES[high_cpu]=false
ALERT_STATES[high_memory]=false
ALERT_STATES[high_disk]=false
ALERT_STATES[slow_response]=false
ALERT_STATES[high_error_rate]=false

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

# Error handling
error_exit() {
    log "ERROR: $1"
    exit 1
}

# Send alert
send_alert() {
    local alert_type="$1"
    local message="$2"
    local severity="${3:-WARNING}"
    
    log "ALERT [${severity}]: ${alert_type} - ${message}"
    
    # Send email alert
    if [ -n "${ALERT_EMAIL}" ]; then
        echo "ALERT [${severity}]: ${alert_type}" > /tmp/alert_email.txt
        echo "Time: $(date)" >> /tmp/alert_email.txt
        echo "Message: ${message}" >> /tmp/alert_email.txt
        echo "Host: $(hostname)" >> /tmp/alert_email.txt
        echo "IP: $(hostname -I | awk '{print $1}')" >> /tmp/alert_email.txt
        
        mail -s "REChain DAO Alert: ${alert_type}" "${ALERT_EMAIL}" < /tmp/alert_email.txt 2>/dev/null || true
        rm -f /tmp/alert_email.txt
    fi
    
    # Send webhook alert
    if [ -n "${ALERT_WEBHOOK}" ]; then
        curl -X POST "${ALERT_WEBHOOK}" \
            -H "Content-Type: application/json" \
            -d "{
                \"text\": \"REChain DAO Alert: ${alert_type}\",
                \"attachments\": [{
                    \"color\": \"${severity,,}\",
                    \"fields\": [{
                        \"title\": \"Alert Type\",
                        \"value\": \"${alert_type}\",
                        \"short\": true
                    }, {
                        \"title\": \"Message\",
                        \"value\": \"${message}\",
                        \"short\": false
                    }, {
                        \"title\": \"Time\",
                        \"value\": \"$(date)\",
                        \"short\": true
                    }, {
                        \"title\": \"Host\",
                        \"value\": \"$(hostname)\",
                        \"short\": true
                    }]
                }]
            }" 2>/dev/null || true
    fi
}

# Check if alert should be sent
should_send_alert() {
    local alert_type="$1"
    local current_state="$2"
    
    if [ "${current_state}" = "true" ] && [ "${ALERT_STATES[${alert_type}]}" = "false" ]; then
        ALERT_STATES[${alert_type}]=true
        return 0
    elif [ "${current_state}" = "false" ] && [ "${ALERT_STATES[${alert_type}]}" = "true" ]; then
        ALERT_STATES[${alert_type}]=false
        return 0
    fi
    
    return 1
}

# Check application health
check_application() {
    local response_time
    local http_code
    local error_count=0
    
    for i in $(seq 1 ${MAX_RETRIES}); do
        response_time=$(curl -o /dev/null -s -w "%{time_total}" \
            "http://${APP_HOST}:${APP_PORT}${APP_HEALTH_ENDPOINT}" 2>/dev/null || echo "9999")
        
        http_code=$(curl -o /dev/null -s -w "%{http_code}" \
            "http://${APP_HOST}:${APP_PORT}${APP_HEALTH_ENDPOINT}" 2>/dev/null || echo "000")
        
        if [ "${http_code}" = "200" ]; then
            break
        else
            error_count=$((error_count + 1))
            sleep 5
        fi
    done
    
    if [ "${http_code}" = "200" ]; then
        log "Application health check passed (${response_time}s)"
        
        # Check response time
        if (( $(echo "${response_time} > ${RESPONSE_TIME_THRESHOLD}" | bc -l) )); then
            if should_send_alert "slow_response" "true"; then
                send_alert "slow_response" "Application response time is ${response_time}s (threshold: ${RESPONSE_TIME_THRESHOLD}ms)" "WARNING"
            fi
        else
            should_send_alert "slow_response" "false"
        fi
        
        return 0
    else
        log "Application health check failed (HTTP ${http_code})"
        
        if should_send_alert "app_down" "true"; then
            send_alert "app_down" "Application is not responding (HTTP ${http_code})" "CRITICAL"
        fi
        
        return 1
    fi
}

# Check database connectivity
check_database() {
    local db_status
    local error_count=0
    
    for i in $(seq 1 ${MAX_RETRIES}); do
        if [ -n "${DB_PASSWORD:-}" ]; then
            db_status=$(mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" -p"${DB_PASSWORD}" \
                -e "SELECT 1;" 2>/dev/null && echo "OK" || echo "FAIL")
        else
            db_status=$(mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" \
                -e "SELECT 1;" 2>/dev/null && echo "OK" || echo "FAIL")
        fi
        
        if [ "${db_status}" = "OK" ]; then
            break
        else
            error_count=$((error_count + 1))
            sleep 5
        fi
    done
    
    if [ "${db_status}" = "OK" ]; then
        log "Database connectivity check passed"
        should_send_alert "db_down" "false"
        return 0
    else
        log "Database connectivity check failed"
        
        if should_send_alert "db_down" "true"; then
            send_alert "db_down" "Database is not accessible" "CRITICAL"
        fi
        
        return 1
    fi
}

# Check Redis connectivity
check_redis() {
    local redis_status
    local error_count=0
    
    for i in $(seq 1 ${MAX_RETRIES}); do
        if [ -n "${REDIS_PASSWORD:-}" ]; then
            redis_status=$(redis-cli -h "${REDIS_HOST}" -p "${REDIS_PORT}" -a "${REDIS_PASSWORD}" \
                ping 2>/dev/null || echo "FAIL")
        else
            redis_status=$(redis-cli -h "${REDIS_HOST}" -p "${REDIS_PORT}" \
                ping 2>/dev/null || echo "FAIL")
        fi
        
        if [ "${redis_status}" = "PONG" ]; then
            break
        else
            error_count=$((error_count + 1))
            sleep 5
        fi
    done
    
    if [ "${redis_status}" = "PONG" ]; then
        log "Redis connectivity check passed"
        should_send_alert "redis_down" "false"
        return 0
    else
        log "Redis connectivity check failed"
        
        if should_send_alert "redis_down" "true"; then
            send_alert "redis_down" "Redis is not accessible" "CRITICAL"
        fi
        
        return 1
    fi
}

# Check system resources
check_system_resources() {
    local cpu_usage
    local memory_usage
    local disk_usage
    
    # CPU usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')
    
    # Memory usage
    memory_usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
    
    # Disk usage
    disk_usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    log "System resources - CPU: ${cpu_usage}%, Memory: ${memory_usage}%, Disk: ${disk_usage}%"
    
    # Check CPU usage
    if (( $(echo "${cpu_usage} > ${CPU_THRESHOLD}" | bc -l) )); then
        if should_send_alert "high_cpu" "true"; then
            send_alert "high_cpu" "CPU usage is ${cpu_usage}% (threshold: ${CPU_THRESHOLD}%)" "WARNING"
        fi
    else
        should_send_alert "high_cpu" "false"
    fi
    
    # Check memory usage
    if (( $(echo "${memory_usage} > ${MEMORY_THRESHOLD}" | bc -l) )); then
        if should_send_alert "high_memory" "true"; then
            send_alert "high_memory" "Memory usage is ${memory_usage}% (threshold: ${MEMORY_THRESHOLD}%)" "WARNING"
        fi
    else
        should_send_alert "high_memory" "false"
    fi
    
    # Check disk usage
    if [ "${disk_usage}" -gt "${DISK_THRESHOLD}" ]; then
        if should_send_alert "high_disk" "true"; then
            send_alert "high_disk" "Disk usage is ${disk_usage}% (threshold: ${DISK_THRESHOLD}%)" "WARNING"
        fi
    else
        should_send_alert "high_disk" "false"
    fi
}

# Check application logs for errors
check_application_logs() {
    local error_count
    local log_file="${LOG_DIR}/application.log"
    
    if [ -f "${log_file}" ]; then
        error_count=$(tail -n 100 "${log_file}" | grep -c "ERROR\|FATAL" || echo "0")
        
        if [ "${error_count}" -gt "${ERROR_RATE_THRESHOLD}" ]; then
            if should_send_alert "high_error_rate" "true"; then
                send_alert "high_error_rate" "High error rate detected: ${error_count} errors in last 100 log entries" "WARNING"
            fi
        else
            should_send_alert "high_error_rate" "false"
        fi
    fi
}

# Check Docker containers
check_docker_containers() {
    if command -v docker >/dev/null 2>&1; then
        local stopped_containers
        stopped_containers=$(docker ps -a --filter "name=rechain-dao" --filter "status=exited" -q | wc -l)
        
        if [ "${stopped_containers}" -gt 0 ]; then
            log "WARNING: ${stopped_containers} rechain-dao containers are stopped"
            send_alert "docker_containers" "${stopped_containers} rechain-dao containers are stopped" "WARNING"
        fi
    fi
}

# Check Kubernetes pods
check_kubernetes_pods() {
    if command -v kubectl >/dev/null 2>&1; then
        local failed_pods
        failed_pods=$(kubectl get pods -l app=rechain-dao --no-headers | grep -v Running | wc -l)
        
        if [ "${failed_pods}" -gt 0 ]; then
            log "WARNING: ${failed_pods} rechain-dao pods are not running"
            send_alert "kubernetes_pods" "${failed_pods} rechain-dao pods are not running" "WARNING"
        fi
    fi
}

# Generate monitoring report
generate_report() {
    local report_file="/tmp/rechain-dao-monitor-report.txt"
    
    cat > "${report_file}" << EOF
REChain DAO Platform Monitoring Report
=====================================

Report Time: $(date)
Host: $(hostname)
IP: $(hostname -I | awk '{print $1}')

System Resources:
- CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
- Memory Usage: $(free | grep Mem | awk '{printf "%.1f%%", $3/$2 * 100.0}')
- Disk Usage: $(df / | tail -1 | awk '{print $5}')

Application Status:
- Application: $(curl -s -o /dev/null -w "%{http_code}" "http://${APP_HOST}:${APP_PORT}${APP_HEALTH_ENDPOINT}" || echo "DOWN")
- Database: $(mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${DB_USER}" -e "SELECT 1;" 2>/dev/null && echo "UP" || echo "DOWN")
- Redis: $(redis-cli -h "${REDIS_HOST}" -p "${REDIS_PORT}" ping 2>/dev/null || echo "DOWN")

Docker Containers:
$(docker ps --filter "name=rechain-dao" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "Docker not available")

Kubernetes Pods:
$(kubectl get pods -l app=rechain-dao 2>/dev/null || echo "Kubernetes not available")

Recent Logs:
$(tail -n 20 "${LOG_FILE}" 2>/dev/null || echo "No logs available")
EOF
    
    log "Monitoring report generated: ${report_file}"
}

# Main monitoring function
main() {
    log "Starting REChain DAO Platform monitoring..."
    
    # Create log directory if it doesn't exist
    mkdir -p "$(dirname "${LOG_FILE}")"
    
    # Check if required tools are installed
    command -v curl >/dev/null 2>&1 || error_exit "curl is required but not installed"
    command -v mysql >/dev/null 2>&1 || error_exit "mysql client is required but not installed"
    command -v redis-cli >/dev/null 2>&1 || error_exit "redis-cli is required but not installed"
    command -v bc >/dev/null 2>&1 || error_exit "bc is required but not installed"
    
    # Run monitoring checks
    check_application
    check_database
    check_redis
    check_system_resources
    check_application_logs
    check_docker_containers
    check_kubernetes_pods
    
    # Generate report
    generate_report
    
    log "Monitoring cycle completed"
}

# Run monitoring in loop
run_continuous() {
    log "Starting continuous monitoring (interval: ${CHECK_INTERVAL}s)"
    
    while true; do
        main
        sleep "${CHECK_INTERVAL}"
    done
}

# Show usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -c, --continuous    Run continuous monitoring"
    echo "  -r, --report        Generate monitoring report only"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "Environment variables:"
    echo "  CHECK_INTERVAL      Monitoring interval in seconds (default: 60)"
    echo "  ALERT_EMAIL         Email address for alerts"
    echo "  ALERT_WEBHOOK       Webhook URL for alerts"
    echo "  APP_HOST            Application host (default: localhost)"
    echo "  APP_PORT            Application port (default: 3000)"
    echo "  DB_HOST             Database host (default: localhost)"
    echo "  DB_PORT             Database port (default: 3306)"
    echo "  REDIS_HOST          Redis host (default: localhost)"
    echo "  REDIS_PORT          Redis port (default: 6379)"
}

# Parse command line arguments
case "${1:-}" in
    -c|--continuous)
        run_continuous
        ;;
    -r|--report)
        generate_report
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        main
        ;;
esac