#!/bin/bash

# ============================================================================
# PRPLOS API Endpoint Testing Script
# ============================================================================
# Description: Comprehensive testing script for PRPLOS WEBUI API endpoints
# Usage: ./prplos_api_test.sh [DUT_IP] [USERNAME] [PASSWORD]
# Author: API Testing Team
# Version: 1.0
# ============================================================================

# Color codes for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DUT_IP="${1:-192.168.1.1}"
USERNAME="${2:-admin}"
PASSWORD="${3:-admin}"
BASE_URL="http://${DUT_IP}"
COOKIE_JAR="/tmp/prplos_session_cookies.txt"
LOG_DIR="./api_test_logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/prplos_api_test_${TIMESTAMP}.log"

# Create log directory
mkdir -p "${LOG_DIR}"

# Global variables
SESSION_ID=""
TEST_COUNT=0
PASSED_TESTS=0
FAILED_TESTS=0

# ============================================================================
# Utility Functions
# ============================================================================

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" | tee -a "${LOG_FILE}"
}

log_info() {
    log "INFO" "${BLUE}$*${NC}"
}

log_success() {
    log "SUCCESS" "${GREEN}$*${NC}"
    ((PASSED_TESTS++))
}

log_error() {
    log "ERROR" "${RED}$*${NC}"
    ((FAILED_TESTS++))
}

log_warning() {
    log "WARNING" "${YELLOW}$*${NC}"
}

print_header() {
    echo -e "\n${PURPLE}============================================================================${NC}"
    echo -e "${PURPLE} $1 ${NC}"
    echo -e "${PURPLE}============================================================================${NC}\n"
}

print_separator() {
    echo -e "\n${CYAN}----------------------------------------------------------------------------${NC}\n"
}

# Check if required tools are available
check_dependencies() {
    print_header "CHECKING DEPENDENCIES"
    
    local deps=("curl" "jq")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        else
            log_info "✓ $dep is available"
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        log_error "Please install: sudo apt-get install curl jq"
        exit 1
    fi
    
    log_success "All dependencies are available"
}

# Test DUT connectivity
test_connectivity() {
    print_header "TESTING DUT CONNECTIVITY"
    
    log_info "Testing connectivity to ${DUT_IP}..."
    
    if ping -c 3 -W 5 "${DUT_IP}" &> /dev/null; then
        log_success "DUT ${DUT_IP} is reachable"
    else
        log_error "DUT ${DUT_IP} is not reachable"
        log_error "Please check network connectivity and DUT IP address"
        exit 1
    fi
}

# Make API call with proper error handling
api_call() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    local description="$4"
    local expected_status="${5:-200}"
    
    ((TEST_COUNT++))
    local test_num=$(printf "%02d" $TEST_COUNT)
    
    log_info "Test ${test_num}: ${description}"
    log_info "Method: ${method} | Endpoint: ${endpoint}"
    
    # Prepare curl command
    local curl_cmd="curl -s -w 'HTTP_STATUS:%{http_code}\nTOTAL_TIME:%{time_total}\nSIZE_DOWNLOAD:%{size_download}\n'"
    curl_cmd+=" -X ${method}"
    curl_cmd+=" -H 'Content-Type: application/json'"
    curl_cmd+=" -H 'Accept: application/json'"
    curl_cmd+=" -c '${COOKIE_JAR}'"
    curl_cmd+=" -b '${COOKIE_JAR}'"
    
    if [ -n "$data" ] && [ "$data" != "null" ]; then
        curl_cmd+=" -d '${data}'"
        log_info "Request Body: ${data}"
    fi
    
    curl_cmd+=" '${BASE_URL}${endpoint}'"
    
    # Execute curl command
    local response=$(eval $curl_cmd)
    local curl_exit_code=$?
    
    # Parse response
    local body=$(echo "$response" | sed '/^HTTP_STATUS:/d; /^TOTAL_TIME:/d; /^SIZE_DOWNLOAD:/d')
    local http_status=$(echo "$response" | grep "HTTP_STATUS:" | cut -d: -f2)
    local total_time=$(echo "$response" | grep "TOTAL_TIME:" | cut -d: -f2)
    local size_download=$(echo "$response" | grep "SIZE_DOWNLOAD:" | cut -d: -f2)
    
    # Log response details
    log_info "HTTP Status: ${http_status}"
    log_info "Response Time: ${total_time}s"
    log_info "Response Size: ${size_download} bytes"
    
    # Pretty print JSON response if valid
    if echo "$body" | jq empty 2>/dev/null; then
        log_info "Response Body (Pretty):"
        echo "$body" | jq '.' | sed 's/^/    /' | tee -a "${LOG_FILE}"
    else
        log_info "Response Body (Raw):"
        echo "    $body" | tee -a "${LOG_FILE}"
    fi
    
    # Validate response
    if [ $curl_exit_code -ne 0 ]; then
        log_error "Test ${test_num} FAILED: curl command failed with exit code ${curl_exit_code}"
        return 1
    fi
    
    if [ "$http_status" = "$expected_status" ]; then
        log_success "Test ${test_num} PASSED: HTTP ${http_status} (Expected: ${expected_status})"
        
        # Extract session ID if present
        if [ "$endpoint" = "/session" ] && [ "$method" = "POST" ]; then
            SESSION_ID=$(echo "$body" | jq -r '.sessionId // .session_id // empty' 2>/dev/null)
            if [ -n "$SESSION_ID" ]; then
                log_info "Session ID extracted: ${SESSION_ID}"
            fi
        fi
        
        return 0
    else
        log_error "Test ${test_num} FAILED: HTTP ${http_status} (Expected: ${expected_status})"
        return 1
    fi
}

# ============================================================================
# API Test Functions
# ============================================================================

test_login_authentication() {
    print_separator
    local login_data="{\"username\": \"${USERNAME}\", \"password\": \"${PASSWORD}\"}"
    api_call "POST" "/session" "$login_data" "Login Authentication" "200"
}

test_session_validation() {
    print_separator
    api_call "GET" "/session" "null" "Session Validation" "200"
}

test_logout() {
    print_separator
    api_call "DELETE" "/session" "null" "Logout" "200"
}

test_password_change() {
    print_separator
    local password_data="{\"current_password\": \"${PASSWORD}\", \"new_password\": \"newpassword123\"}"
    api_call "PUT" "/session/password" "$password_data" "Password Change" "200"
}

test_password_reset_request() {
    print_separator
    local reset_data="{\"username\": \"${USERNAME}\"}"
    api_call "POST" "/session/reset" "$reset_data" "Password Reset Request" "200"
}

test_password_reset_confirm() {
    print_separator
    local confirm_data="{\"reset_token\": \"dummy_token_123\", \"new_password\": \"resetpassword123\"}"
    api_call "POST" "/session/reset/confirm" "$confirm_data" "Password Reset Confirm" "200"
}

test_system_status() {
    print_separator
    api_call "GET" "/system/status" "null" "System Overview" "200"
}

test_device_info() {
    print_separator
    api_call "GET" "/system/info" "null" "Device Information" "200"
}

test_network_statistics() {
    print_separator
    api_call "GET" "/network/statistics" "null" "Network Statistics" "200"
}

test_active_connections() {
    print_separator
    api_call "GET" "/network/connections" "null" "Active Connections" "200"
}

test_quick_actions() {
    print_separator
    local action_data="{\"action\": \"status_check\", \"params\": {}}"
    api_call "POST" "/system/actions" "$action_data" "Quick Actions" "200"
}

test_system_logs() {
    print_separator
    api_call "GET" "/system/logs" "null" "System Logs" "200"
}

test_temperature_status() {
    print_separator
    api_call "GET" "/system/temperature" "null" "Temperature Status" "200"
}

test_storage_status() {
    print_separator
    api_call "GET" "/system/storage" "null" "Storage Status" "200"
}

# ============================================================================
# Test Re-authentication (for authenticated endpoints)
# ============================================================================

re_authenticate() {
    print_separator
    log_info "Re-authenticating for protected endpoint tests..."
    test_login_authentication
}

# ============================================================================
# Main Test Execution
# ============================================================================

main() {
    print_header "PRPLOS API ENDPOINT TESTING"
    
    log_info "DUT IP: ${DUT_IP}"
    log_info "Username: ${USERNAME}"
    log_info "Log File: ${LOG_FILE}"
    log_info "Cookie Jar: ${COOKIE_JAR}"
    
    # Initialize
    rm -f "${COOKIE_JAR}"
    
    # Dependency and connectivity checks
    check_dependencies
    test_connectivity
    
    print_header "AUTHENTICATION TESTS"
    
    # Authentication tests
    test_login_authentication
    test_session_validation
    
    # Note: We'll test logout later to maintain session for other tests
    
    print_header "PASSWORD MANAGEMENT TESTS"
    
    # Password management tests (may fail on some systems)
    test_password_change
    test_password_reset_request
    test_password_reset_confirm
    
    print_header "DASHBOARD ENDPOINT TESTS"
    
    # Re-authenticate to ensure valid session
    re_authenticate
    
    # Dashboard tests
    test_system_status
    test_device_info
    test_network_statistics
    test_active_connections
    test_quick_actions
    test_system_logs
    test_temperature_status
    test_storage_status
    
    print_header "SESSION CLEANUP"
    
    # Test logout at the end
    test_logout
    
    # Cleanup
    rm -f "${COOKIE_JAR}"
    
    print_header "TEST SUMMARY"
    
    log_info "Total Tests: ${TEST_COUNT}"
    log_success "Passed: ${PASSED_TESTS}"
    log_error "Failed: ${FAILED_TESTS}"
    
    local success_rate=$((PASSED_TESTS * 100 / TEST_COUNT))
    log_info "Success Rate: ${success_rate}%"
    
    if [ $FAILED_TESTS -eq 0 ]; then
        log_success "ALL TESTS PASSED! 🎉"
        exit 0
    else
        log_warning "Some tests failed. Check the log file for details: ${LOG_FILE}"
        exit 1
    fi
}

# ============================================================================
# Signal Handling
# ============================================================================

cleanup() {
    log_warning "Script interrupted. Cleaning up..."
    rm -f "${COOKIE_JAR}"
    exit 130
}

trap cleanup INT TERM

# ============================================================================
# Help Function
# ============================================================================

show_help() {
    cat << EOF
PRPLOS API Endpoint Testing Script

Usage: $0 [DUT_IP] [USERNAME] [PASSWORD]

Parameters:
  DUT_IP      IP address of the PRPLOS device (default: 192.168.1.1)
  USERNAME    Login username (default: admin)
  PASSWORD    Login password (default: admin)

Examples:
  $0                                    # Use defaults
  $0 192.168.1.100                     # Custom IP
  $0 192.168.1.100 admin mypassword    # Custom IP and credentials

Output:
  - Console output with colored status messages
  - Detailed log file in ./api_test_logs/
  - Session cookies stored temporarily in /tmp/

Requirements:
  - curl (for API calls)
  - jq (for JSON processing)
  - Network connectivity to DUT

EOF
}

# ============================================================================
# Entry Point
# ============================================================================

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Run main function
main "$@"