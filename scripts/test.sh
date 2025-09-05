#!/bin/bash

# REChain DAO Platform Testing Script
set -euo pipefail

# Configuration
TEST_DIR="/tmp/rechain-dao-tests"
LOG_FILE="/var/log/rechain-dao/test.log"
APP_HOST="${APP_HOST:-localhost}"
APP_PORT="${APP_PORT:-3000}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Logging function
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "${LOG_FILE}"
}

# Test result functions
test_pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    ((PASSED_TESTS++))
    ((TOTAL_TESTS++))
}

test_fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    ((FAILED_TESTS++))
    ((TOTAL_TESTS++))
}

# Check if service is responding
check_service() {
    local url="$1"
    local expected_status="${2:-200}"
    local timeout="${3:-10}"
    
    local status_code
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time "${timeout}" "${url}" 2>/dev/null || echo "000")
    
    if [ "${status_code}" = "${expected_status}" ]; then
        return 0
    else
        return 1
    fi
}

# Test application health
test_application_health() {
    log "Testing application health..."
    
    local health_url="http://${APP_HOST}:${APP_PORT}/health"
    
    if check_service "${health_url}" 200; then
        test_pass "Application health check"
    else
        test_fail "Application health check"
    fi
}

# Test application endpoints
test_application_endpoints() {
    log "Testing application endpoints..."
    
    local endpoints=(
        "http://${APP_HOST}:${APP_PORT}/api/health"
        "http://${APP_HOST}:${APP_PORT}/api/version"
        "http://${APP_HOST}:${APP_PORT}/api/status"
    )
    
    for endpoint in "${endpoints[@]}"; do
        if check_service "${endpoint}" 200; then
            test_pass "Endpoint ${endpoint}"
        else
            test_fail "Endpoint ${endpoint}"
        fi
    done
}

# Test system resources
test_system_resources() {
    log "Testing system resources..."
    
    # Check CPU usage
    local cpu_usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')
    
    if (( $(echo "${cpu_usage} < 80" | bc -l) )); then
        test_pass "CPU usage is acceptable (${cpu_usage}%)"
    else
        test_fail "CPU usage is too high (${cpu_usage}%)"
    fi
    
    # Check memory usage
    local memory_usage
    memory_usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
    
    if [ "${memory_usage}" -lt 90 ]; then
        test_pass "Memory usage is acceptable (${memory_usage}%)"
    else
        test_fail "Memory usage is too high (${memory_usage}%)"
    fi
}

# Test Docker containers
test_docker_containers() {
    log "Testing Docker containers..."
    
    if command -v docker >/dev/null 2>&1; then
        local containers
        containers=$(docker ps --filter "name=rechain-dao" --format "{{.Names}}" | wc -l)
        
        if [ "${containers}" -gt 0 ]; then
            test_pass "Docker containers are running (${containers} containers)"
        else
            test_fail "No rechain-dao containers are running"
        fi
    else
        test_fail "Docker not available"
    fi
}

# Generate test report
generate_test_report() {
    log "Generating test report..."
    
    local report_file="${TEST_DIR}/test-report.txt"
    
    cat > "${report_file}" << EOF
REChain DAO Platform Test Report
================================

Test Date: $(date)
Test Environment: ${ENVIRONMENT:-production}
Application Host: ${APP_HOST}:${APP_PORT}

Test Results:
- Total Tests: ${TOTAL_TESTS}
- Passed: ${PASSED_TESTS}
- Failed: ${FAILED_TESTS}
- Success Rate: $(( (PASSED_TESTS * 100) / TOTAL_TESTS ))%

System Information:
- OS: $(uname -s)
- Kernel: $(uname -r)
- Architecture: $(uname -m)
- CPU: $(nproc) cores
- Memory: $(free -h | awk 'NR==2{print $2}')
- Disk: $(df -h / | awk 'NR==2{print $2}')
EOF
    
    log "Test report generated: ${report_file}"
}

# Main test function
main() {
    log "Starting REChain DAO Platform tests..."
    
    # Create test directory
    mkdir -p "${TEST_DIR}"
    
    # Run tests
    test_application_health
    test_application_endpoints
    test_system_resources
    test_docker_containers
    
    # Generate report
    generate_test_report
    
    # Display summary
    echo ""
    echo "=========================================="
    echo "Test Summary:"
    echo "Total Tests: ${TOTAL_TESTS}"
    echo "Passed: ${PASSED_TESTS}"
    echo "Failed: ${FAILED_TESTS}"
    echo "Success Rate: $(( (PASSED_TESTS * 100) / TOTAL_TESTS ))%"
    echo "=========================================="
    
    # Exit with appropriate code
    if [ ${FAILED_TESTS} -eq 0 ]; then
        log "All tests passed!"
        exit 0
    else
        log "Some tests failed!"
        exit 1
    fi
}

# Run main function
main "$@"