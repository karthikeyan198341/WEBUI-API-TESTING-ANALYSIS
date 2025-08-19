# Insomnia Post-Response Scripts for prplOS API Testing

## 🎯 **Universal Post-Response Script (All Endpoints)**

```javascript
// ================== UNIVERSAL prplOS API RESPONSE HANDLER ==================
// Place this script in the "After Response" tab of each request in Insomnia

const response = insomnia.response;
const statusCode = response.getStatusCode();
const responseTime = response.getResponseTime();
const requestName = insomnia.request.getName();

console.log("=".repeat(80));
console.log(`🔍 TESTING: ${requestName}`);
console.log(`📊 Status Code: ${statusCode} | ⏱️ Response Time: ${responseTime}ms`);
console.log("=".repeat(80));

// Parse response body
let responseBody;
try {
    responseBody = JSON.parse(response.getBodyText());
} catch (e) {
    responseBody = response.getBodyText();
}

// SUCCESS HANDLING (2xx status codes)
if (statusCode >= 200 && statusCode < 300) {
    console.log("✅ SUCCESS - Request completed successfully");
    
    if (typeof responseBody === 'object' && responseBody !== null) {
        // Handle successful JSON responses
        const extractedData = {};
        let hasData = false;

        // Common success patterns in prplOS
        if (responseBody.success !== undefined) {
            extractedData.success = responseBody.success;
            hasData = true;
        }

        if (responseBody.message) {
            extractedData.message = responseBody.message;
            hasData = true;
        }

        if (responseBody.status) {
            extractedData.status = responseBody.status;
            hasData = true;
        }

        // LOGIN specific data
        if (responseBody.sessionId) {
            extractedData.sessionId = responseBody.sessionId;
            extractedData.expires = responseBody.expires;
            hasData = true;
        }

        if (responseBody.valid !== undefined) {
            extractedData.sessionValid = responseBody.valid;
            hasData = true;
        }

        if (responseBody.user) {
            extractedData.userInfo = `Username: ${responseBody.user.username || 'N/A'}`;
            hasData = true;
        }

        // DASHBOARD specific data
        if (responseBody.cpu_usage !== undefined) {
            extractedData.cpuUsage = `${responseBody.cpu_usage}%`;
            hasData = true;
        }

        if (responseBody.memory) {
            extractedData.memoryUsage = `${responseBody.memory.used || 'N/A'}/${responseBody.memory.total || 'N/A'}`;
            hasData = true;
        }

        if (responseBody.uptime) {
            extractedData.uptime = responseBody.uptime;
            hasData = true;
        }

        if (responseBody.model) {
            extractedData.deviceModel = responseBody.model;
            extractedData.firmware = responseBody.firmware;
            extractedData.serial = responseBody.serial;
            hasData = true;
        }

        if (responseBody.interfaces) {
            extractedData.interfaceCount = Object.keys(responseBody.interfaces).length;
            hasData = true;
        }

        if (responseBody.connections) {
            extractedData.activeConnections = Array.isArray(responseBody.connections) ? 
                responseBody.connections.length : responseBody.connections;
            hasData = true;
        }

        if (responseBody.total !== undefined) {
            extractedData.totalRecords = responseBody.total;
            hasData = true;
        }

        if (responseBody.cpu_temp !== undefined) {
            extractedData.cpuTemp = `${responseBody.cpu_temp}°C`;
            hasData = true;
        }

        if (responseBody.board_temp !== undefined) {
            extractedData.boardTemp = `${responseBody.board_temp}°C`;
            hasData = true;
        }

        if (responseBody.partitions) {
            extractedData.storagePartitions = responseBody.partitions.length;
            extractedData.totalSpace = responseBody.total_space;
            extractedData.usedSpace = responseBody.used_space;
            hasData = true;
        }

        if (responseBody.processes) {
            extractedData.processCount = Array.isArray(responseBody.processes) ? 
                responseBody.processes.length : responseBody.processes;
            hasData = true;
        }

        if (responseBody.logs) {
            extractedData.logEntries = Array.isArray(responseBody.logs) ? 
                responseBody.logs.length : 'Log data available';
            hasData = true;
        }

        if (responseBody.restart_required !== undefined) {
            extractedData.restartRequired = responseBody.restart_required;
            hasData = true;
        }

        // ServiceElements specific
        if (responseBody.services) {
            extractedData.serviceCount = Array.isArray(responseBody.services) ? 
                responseBody.services.length : responseBody.services;
            hasData = true;
        }

        if (responseBody.service_id) {
            extractedData.serviceId = responseBody.service_id;
            hasData = true;
        }

        // Display results
        if (hasData) {
            console.log("📋 EXTRACTED PARAMETERS:");
            Object.entries(extractedData).forEach(([key, value]) => {
                console.log(`   ${key}: ${value}`);
            });
        } else {
            console.log("📋 RESPONSE DATA: NA (Empty response or no recognizable data)");
        }

        // Show raw response if it's small
        const bodyText = JSON.stringify(responseBody, null, 2);
        if (bodyText.length < 500) {
            console.log("📄 FULL RESPONSE:");
            console.log(bodyText);
        } else {
            console.log("📄 RESPONSE: Large response body (>500 chars) - check Response tab");
        }

    } else if (typeof responseBody === 'string') {
        // Handle binary/text responses (like downloads)
        if (responseBody.length > 0) {
            console.log(`📋 RESPONSE: Text/Binary data received (${responseBody.length} bytes)`);
            if (responseBody.length < 200) {
                console.log(`📄 CONTENT: ${responseBody}`);
            }
        } else {
            console.log("📋 RESPONSE DATA: NA (Empty text response)");
        }
    } else {
        console.log("📋 RESPONSE DATA: NA (No response body)");
    }

} else {
    // ERROR HANDLING (Non-2xx status codes)
    console.log(`❌ FAILURE - Request failed with status ${statusCode}`);
    
    // Detailed error handling based on status code
    let errorCategory = "";
    let errorAction = "";
    
    switch (statusCode) {
        case 400:
            errorCategory = "Bad Request";
            errorAction = "Check request parameters and JSON format";
            break;
        case 401:
            errorCategory = "Unauthorized";
            errorAction = "Authentication required - run LOGIN request first";
            break;
        case 403:
            errorCategory = "Forbidden";
            errorAction = "Access denied - check user permissions";
            break;
        case 404:
            errorCategory = "Not Found";
            errorAction = "Endpoint not found - verify URL path";
            break;
        case 405:
            errorCategory = "Method Not Allowed";
            errorAction = "Check HTTP method (GET/POST/PUT/DELETE)";
            break;
        case 408:
            errorCategory = "Request Timeout";
            errorAction = "Request timed out - try again or check network";
            break;
        case 409:
            errorCategory = "Conflict";
            errorAction = "Resource conflict - check if resource already exists";
            break;
        case 413:
            errorCategory = "Payload Too Large";
            errorAction = "File or data too large - reduce size";
            break;
        case 422:
            errorCategory = "Unprocessable Entity";
            errorAction = "Validation failed - check data format";
            break;
        case 429:
            errorCategory = "Too Many Requests";
            errorAction = "Rate limit exceeded - wait before retrying";
            break;
        case 500:
            errorCategory = "Internal Server Error";
            errorAction = "Server error - contact system administrator";
            break;
        case 501:
            errorCategory = "Not Implemented";
            errorAction = "Feature not implemented";
            break;
        case 502:
            errorCategory = "Bad Gateway";
            errorAction = "Server communication error";
            break;
        case 503:
            errorCategory = "Service Unavailable";
            errorAction = "Service temporarily down - try again later";
            break;
        default:
            errorCategory = "Unknown Error";
            errorAction = "Unexpected status code";
    }
    
    console.log(`📊 ERROR TYPE: ${errorCategory}`);
    console.log(`🔧 SUGGESTED ACTION: ${errorAction}`);
    
    // Show error response body if available
    if (responseBody) {
        if (typeof responseBody === 'object') {
            console.log("📄 ERROR DETAILS:");
            if (responseBody.error) {
                console.log(`   Error: ${responseBody.error}`);
            }
            if (responseBody.message) {
                console.log(`   Message: ${responseBody.message}`);
            }
            if (responseBody.code) {
                console.log(`   Code: ${responseBody.code}`);
            }
            if (responseBody.details) {
                console.log(`   Details: ${JSON.stringify(responseBody.details)}`);
            }
            
            // Show full error if it's small
            const errorText = JSON.stringify(responseBody, null, 2);
            if (errorText.length < 300) {
                console.log("📄 FULL ERROR RESPONSE:");
                console.log(errorText);
            }
        } else {
            console.log(`📄 ERROR RESPONSE: ${responseBody}`);
        }
    } else {
        console.log("📄 ERROR RESPONSE: No error details provided");
    }
}

console.log("=".repeat(80));
console.log("");
```

## 🔐 **LOGIN-Specific Post-Response Script**

```javascript
// ================== LOGIN ENDPOINTS SPECIFIC HANDLER ==================
// Use this for LOGIN collection requests for more detailed authentication handling

const response = insomnia.response;
const statusCode = response.getStatusCode();
const requestName = insomnia.request.getName();

console.log(`🔐 LOGIN TEST: ${requestName}`);
console.log(`📊 Status: ${statusCode} | ⏱️ Time: ${response.getResponseTime()}ms`);

let responseBody;
try {
    responseBody = JSON.parse(response.getBodyText());
} catch (e) {
    responseBody = response.getBodyText();
}

if (statusCode >= 200 && statusCode < 300) {
    console.log("✅ AUTHENTICATION SUCCESS");
    
    if (requestName.includes("Login")) {
        if (responseBody.success && responseBody.sessionId) {
            console.log("📋 LOGIN PARAMETERS:");
            console.log(`   Session ID: ${responseBody.sessionId}`);
            console.log(`   Expires: ${responseBody.expires || 'Not specified'}`);
            console.log(`   User: ${responseBody.user?.username || 'Not specified'}`);
            console.log("🍪 Session cookies should be automatically stored");
        } else {
            console.log("📋 LOGIN RESPONSE: NA (Missing expected login data)");
        }
    } else if (requestName.includes("Validation")) {
        if (responseBody.valid !== undefined) {
            console.log("📋 SESSION VALIDATION:");
            console.log(`   Valid: ${responseBody.valid}`);
            console.log(`   User: ${responseBody.user?.username || 'Not specified'}`);
            console.log(`   Expires: ${responseBody.expires || 'Not specified'}`);
        } else {
            console.log("📋 VALIDATION RESPONSE: NA (No validation data)");
        }
    } else if (requestName.includes("Password")) {
        if (responseBody.success) {
            console.log("📋 PASSWORD CHANGE:");
            console.log(`   Status: ${responseBody.message || 'Password updated successfully'}`);
        } else {
            console.log("📋 PASSWORD RESPONSE: NA (No success confirmation)");
        }
    } else if (requestName.includes("Reset")) {
        if (responseBody.success) {
            console.log("📋 PASSWORD RESET:");
            console.log(`   Reset Token: ${responseBody.reset_token || 'Generated'}`);
            console.log(`   Message: ${responseBody.message || 'Reset email sent'}`);
        } else {
            console.log("📋 RESET RESPONSE: NA (No reset confirmation)");
        }
    } else if (requestName.includes("Logout")) {
        if (responseBody.success) {
            console.log("📋 LOGOUT:");
            console.log(`   Status: ${responseBody.message || 'Session terminated'}`);
            console.log("🍪 Session cookies should be cleared");
        } else {
            console.log("📋 LOGOUT RESPONSE: NA (No logout confirmation)");
        }
    }
} else {
    console.log("❌ AUTHENTICATION FAILED");
    
    // Specific auth error handling
    if (statusCode === 401) {
        console.log("🔒 REASON: Invalid credentials");
        console.log("🔧 ACTION: Check username/password (admin/admin)");
    } else if (statusCode === 429) {
        console.log("🔒 REASON: Too many login attempts");
        console.log("🔧 ACTION: Wait before retrying login");
    } else if (statusCode === 403) {
        console.log("🔒 REASON: Account locked or access denied");
        console.log("🔧 ACTION: Contact system administrator");
    }
    
    if (responseBody && responseBody.error) {
        console.log(`📄 ERROR DETAILS: ${responseBody.error}`);
    }
}

console.log("=".repeat(50));
```

## 📊 **DASHBOARD-Specific Post-Response Script**

```javascript
// ================== DASHBOARD ENDPOINTS SPECIFIC HANDLER ==================
// Use this for DASHBOARD collection requests for detailed system monitoring

const response = insomnia.response;
const statusCode = response.getStatusCode();
const requestName = insomnia.request.getName();

console.log(`📊 DASHBOARD TEST: ${requestName}`);
console.log(`📊 Status: ${statusCode} | ⏱️ Time: ${response.getResponseTime()}ms`);

let responseBody;
try {
    responseBody = JSON.parse(response.getBodyText());
} catch (e) {
    responseBody = response.getBodyText();
}

if (statusCode >= 200 && statusCode < 300) {
    console.log("✅ DASHBOARD DATA SUCCESS");
    
    if (requestName.includes("System Overview")) {
        if (responseBody.cpu_usage !== undefined) {
            console.log("📋 SYSTEM OVERVIEW:");
            console.log(`   CPU Usage: ${responseBody.cpu_usage}%`);
            console.log(`   Memory Used: ${responseBody.memory?.used || 'NA'}`);
            console.log(`   Memory Total: ${responseBody.memory?.total || 'NA'}`);
            console.log(`   Uptime: ${responseBody.uptime || 'NA'}`);
            console.log(`   Load Average: ${JSON.stringify(responseBody.load_average) || 'NA'}`);
        } else {
            console.log("📋 SYSTEM DATA: NA (No system metrics found)");
        }
    } else if (requestName.includes("Device Information")) {
        if (responseBody.model) {
            console.log("📋 DEVICE INFORMATION:");
            console.log(`   Model: ${responseBody.model}`);
            console.log(`   Firmware: ${responseBody.firmware || 'NA'}`);
            console.log(`   Serial: ${responseBody.serial || 'NA'}`);
            console.log(`   MAC: ${responseBody.mac || 'NA'}`);
        } else {
            console.log("📋 DEVICE DATA: NA (No device information found)");
        }
    } else if (requestName.includes("Network Statistics")) {
        if (responseBody.interfaces || responseBody.traffic) {
            console.log("📋 NETWORK STATISTICS:");
            console.log(`   Interfaces: ${responseBody.interfaces ? Object.keys(responseBody.interfaces).length : 'NA'}`);
            console.log(`   Active Connections: ${responseBody.connections || 'NA'}`);
            console.log(`   Traffic Data: ${responseBody.traffic ? 'Available' : 'NA'}`);
        } else {
            console.log("📋 NETWORK DATA: NA (No network statistics found)");
        }
    } else if (requestName.includes("Active Connections")) {
        if (responseBody.total !== undefined) {
            console.log("📋 ACTIVE CONNECTIONS:");
            console.log(`   Total Connections: ${responseBody.total}`);
            console.log(`   Returned Records: ${responseBody.connections?.length || 'NA'}`);
        } else {
            console.log("📋 CONNECTION DATA: NA (No connection information found)");
        }
    } else if (requestName.includes("System Logs")) {
        if (typeof responseBody === 'string' || responseBody.logs) {
            console.log("📋 SYSTEM LOGS (SYSLOG):");
            if (typeof responseBody === 'string') {
                console.log(`   Log Data: ${responseBody.length} bytes received`);
                console.log(`   Format: Raw text/binary`);
            } else {
                console.log(`   Log Entries: ${responseBody.logs?.length || 'NA'}`);
                console.log(`   Total Logs: ${responseBody.total || 'NA'}`);
            }
        } else {
            console.log("📋 LOG DATA: NA (No log data found)");
        }
    } else if (requestName.includes("Quick Actions")) {
        if (responseBody.success) {
            console.log("📋 QUICK ACTION:");
            console.log(`   Action Result: ${responseBody.result || 'Completed'}`);
            console.log(`   Message: ${responseBody.message || 'Action executed'}`);
        } else {
            console.log("📋 ACTION RESULT: NA (No action confirmation)");
        }
    } else if (requestName.includes("Temperature")) {
        if (responseBody.cpu_temp !== undefined) {
            console.log("📋 TEMPERATURE STATUS:");
            console.log(`   CPU Temperature: ${responseBody.cpu_temp}°C`);
            console.log(`   Board Temperature: ${responseBody.board_temp || 'NA'}°C`);
            console.log(`   Status: ${responseBody.status || 'NA'}`);
        } else {
            console.log("📋 TEMPERATURE DATA: NA (No temperature readings found)");
        }
    } else if (requestName.includes("Storage")) {
        if (responseBody.partitions) {
            console.log("📋 STORAGE STATUS:");
            console.log(`   Partitions: ${responseBody.partitions.length}`);
            console.log(`   Total Space: ${responseBody.total_space || 'NA'}`);
            console.log(`   Used Space: ${responseBody.used_space || 'NA'}`);
        } else {
            console.log("📋 STORAGE DATA: NA (No storage information found)");
        }
    } else if (requestName.includes("Process")) {
        if (responseBody.processes) {
            console.log("📋 PROCESS STATUS:");
            console.log(`   Running Processes: ${responseBody.processes.length}`);
            console.log(`   Total Count: ${responseBody.total || 'NA'}`);
        } else {
            console.log("📋 PROCESS DATA: NA (No process information found)");
        }
    } else if (requestName.includes("Health")) {
        if (responseBody.status) {
            console.log("📋 SYSTEM HEALTH:");
            console.log(`   Health Status: ${responseBody.status}`);
            console.log(`   Uptime: ${responseBody.uptime || 'NA'}`);
            console.log(`   Health Checks: ${responseBody.checks?.length || 'NA'} items`);
        } else {
            console.log("📋 HEALTH DATA: NA (No health information found)");
        }
    }
} else {
    console.log("❌ DASHBOARD DATA FAILED");
    
    // Specific dashboard error handling
    if (statusCode === 401) {
        console.log("🔒 REASON: Session expired or not authenticated");
        console.log("🔧 ACTION: Run LOGIN request first");
    } else if (statusCode === 503) {
        console.log("🔒 REASON: Service unavailable");
        console.log("🔧 ACTION: Check if prplOS services are running");
    } else if (statusCode === 404) {
        console.log("🔒 REASON: Endpoint not found");
        console.log("🔧 ACTION: Verify serviceElements endpoint paths");
    }
    
    if (responseBody && typeof responseBody === 'object') {
        console.log(`📄 ERROR: ${responseBody.error || responseBody.message || 'Unknown error'}`);
    }
}

console.log("=".repeat(50));
```

## 🚀 **How to Use These Scripts:**

### **1. Universal Script (Recommended):**
- Copy the **Universal Post-Response Script**
- Add it to the "After Response" tab of each request
- Works for both LOGIN and DASHBOARD endpoints
- Provides comprehensive parameter extraction

### **2. Specific Scripts:**
- Use **LOGIN-Specific** script for authentication requests
- Use **DASHBOARD-Specific** script for monitoring requests
- More detailed output for specific endpoint types

### **3. Adding Scripts to Insomnia:**
1. Open any request in Insomnia
2. Click the "Scripts" tab at the bottom
3. Select "After Response" tab
4. Paste the script code
5. Save and run the request

### **4. Expected Output Examples:**

**SUCCESS Example:**
```
===============================================================================
🔍 TESTING: System Overview
📊 Status Code: 200 | ⏱️ Response Time: 245ms
===============================================================================
✅ SUCCESS - Request completed successfully
📋 EXTRACTED PARAMETERS:
   cpuUsage: 15.2%
   memoryUsage: 512MB/2GB
   uptime: 2d 14h 32m
   restartRequired: false
📄 FULL RESPONSE:
{
  "cpu_usage": 15.2,
  "memory": {"used": "512MB", "total": "2GB"},
  "uptime": "2d 14h 32m"
}
```

**FAILURE Example:**
```
===============================================================================
🔍 TESTING: System Overview
📊 Status Code: 401 | ⏱️ Response Time: 123ms
===============================================================================
❌ FAILURE - Request failed with status 401
📊 ERROR TYPE: Unauthorized
🔧 SUGGESTED ACTION: Authentication required - run LOGIN request first
📄 ERROR DETAILS:
   Error: Session expired
   Message: Please login again
```

These scripts will give you comprehensive feedback on every API call, extracting meaningful data and providing clear guidance on any issues!


Based on my research and typical patterns in prplOS and Ambiorix framework, here's a comprehensive guide for zone-based logging in the tr181-httpprocess package:

## Zone-Based Logging Command Reference Guide for tr181-httpprocess

### Overview
Zone-based logging in prplOS tr181-httpprocess allows granular control over log output by categorizing logs into different functional zones. Each zone can be independently enabled/disabled for targeted debugging.

### 1. **Environment Variable Configuration**

Set up zone-based logging using environment variables:

```bash
# Enable all zones
export AMXRT_LOG_ZONES="all"

# Enable specific zones
export AMXRT_LOG_ZONES="session,dm,dm_userintf,config,main"

# Set logging level
export AMXRT_LOG_LEVEL="DEBUG"
export AMXRT_LOG_FACILITY="local0"
```

### 2. **Zone-Specific Configuration Commands**

#### **Session Zone Logging**
```bash
# Enable session zone logging
amxrt_set_log_zone session enable
amxrt_set_log_zone session debug

# Using environment variable
export AMXRT_LOG_ZONE_SESSION=1
export AMXRT_LOG_ZONE_SESSION_LEVEL=DEBUG

# Runtime configuration
echo "session:debug" > /proc/ambiorix/log_zones
```

#### **DM (Data Model) Zone Logging**
```bash
# Enable DM zone logging
amxrt_set_log_zone dm enable
amxrt_set_log_zone dm debug

# Using environment variable
export AMXRT_LOG_ZONE_DM=1
export AMXRT_LOG_ZONE_DM_LEVEL=DEBUG

# Runtime configuration
echo "dm:debug" > /proc/ambiorix/log_zones
```

#### **DM_UserIntf Zone Logging**
```bash
# Enable DM user interface zone logging
amxrt_set_log_zone dm_userintf enable
amxrt_set_log_zone dm_userintf debug

# Using environment variable
export AMXRT_LOG_ZONE_DM_USERINTF=1
export AMXRT_LOG_ZONE_DM_USERINTF_LEVEL=DEBUG

# Runtime configuration
echo "dm_userintf:debug" > /proc/ambiorix/log_zones
```

#### **Config Zone Logging**
```bash
# Enable configuration zone logging
amxrt_set_log_zone config enable
amxrt_set_log_zone config debug

# Using environment variable
export AMXRT_LOG_ZONE_CONFIG=1
export AMXRT_LOG_ZONE_CONFIG_LEVEL=DEBUG

# Runtime configuration
echo "config:debug" > /proc/ambiorix/log_zones
```

#### **Main Zone Logging**
```bash
# Enable main zone logging
amxrt_set_log_zone main enable
amxrt_set_log_zone main debug

# Using environment variable
export AMXRT_LOG_ZONE_MAIN=1
export AMXRT_LOG_ZONE_MAIN_LEVEL=DEBUG

# Runtime configuration
echo "main:debug" > /proc/ambiorix/log_zones
```

### 3. **Configuration File Method**

Create or modify `/etc/ambiorix/tr181-httpprocess.conf`:

```ini
[logging]
enabled = true
level = DEBUG
facility = local0

[log_zones]
session = DEBUG
dm = DEBUG
dm_userintf = DEBUG
config = DEBUG
main = DEBUG

[zone_session]
enabled = true
level = DEBUG
output = /var/log/tr181/session.log

[zone_dm]
enabled = true
level = DEBUG
output = /var/log/tr181/dm.log

[zone_dm_userintf]
enabled = true
level = DEBUG
output = /var/log/tr181/dm_userintf.log

[zone_config]
enabled = true
level = DEBUG
output = /var/log/tr181/config.log

[zone_main]
enabled = true
level = DEBUG
output = /var/log/tr181/main.log
```

### 4. **Runtime Control Using UCI (if available)**

```bash
# Enable zones using UCI
uci set tr181_httpprocess.logging.zones="session,dm,dm_userintf,config,main"
uci set tr181_httpprocess.logging.level="DEBUG"

# Zone-specific settings
uci set tr181_httpprocess.zone_session.enabled=1
uci set tr181_httpprocess.zone_session.level="DEBUG"

uci set tr181_httpprocess.zone_dm.enabled=1
uci set tr181_httpprocess.zone_dm.level="DEBUG"

uci set tr181_httpprocess.zone_dm_userintf.enabled=1
uci set tr181_httpprocess.zone_dm_userintf.level="DEBUG"

uci set tr181_httpprocess.zone_config.enabled=1
uci set tr181_httpprocess.zone_config.level="DEBUG"

uci set tr181_httpprocess.zone_main.enabled=1
uci set tr181_httpprocess.zone_main.level="DEBUG"

# Apply changes
uci commit
/etc/init.d/tr181-httpprocess restart
```

### 5. **Dynamic Runtime Control**

```bash
# Using control socket (if available)
amxrt_cli -s /var/run/tr181-httpprocess.sock <<EOF
logging zone session enable
logging zone dm enable
logging zone dm_userintf enable
logging zone config enable
logging zone main enable
logging level DEBUG
EOF

# Using signals for dynamic control
# Enable debug logging
kill -USR1 $(pidof tr181-httpprocess)

# Disable debug logging
kill -USR2 $(pidof tr181-httpprocess)
```

### 6. **Systemd Service Configuration**

If tr181-httpprocess runs as a systemd service:

```bash
# Create override configuration
systemctl edit tr181-httpprocess

# Add environment variables
[Service]
Environment="AMXRT_LOG_ZONES=session,dm,dm_userintf,config,main"
Environment="AMXRT_LOG_LEVEL=DEBUG"
Environment="AMXRT_LOG_ZONE_SESSION=1"
Environment="AMXRT_LOG_ZONE_DM=1"
Environment="AMXRT_LOG_ZONE_DM_USERINTF=1"
Environment="AMXRT_LOG_ZONE_CONFIG=1"
Environment="AMXRT_LOG_ZONE_MAIN=1"

# Reload and restart
systemctl daemon-reload
systemctl restart tr181-httpprocess
```

### 7. **Monitoring Zone Logs**

```bash
# Monitor all zones
tail -f /var/log/tr181/*.log

# Monitor specific zone
tail -f /var/log/tr181/session.log

# Using journalctl (if systemd)
journalctl -u tr181-httpprocess -f | grep -E "ZONE:(session|dm|config)"

# Filter by zone
grep "ZONE:session" /var/log/syslog
grep "ZONE:dm" /var/log/syslog
grep "ZONE:dm_userintf" /var/log/syslog
grep "ZONE:config" /var/log/syslog
grep "ZONE:main" /var/log/syslog
```

### 8. **Verification Commands**

```bash
# Check current zone status
cat /proc/ambiorix/log_zones

# Query current configuration
amxrt_cli -c "show logging zones"

# Check environment variables
env | grep AMXRT_LOG

# Verify log output
logger -t tr181-test -p local0.debug "Test message"
tail -n 10 /var/log/syslog | grep tr181
```

### 9. **Log Level Reference**

```bash
# Available log levels for each zone
FATAL   = 0  # System unusable
ERROR   = 1  # Error conditions
WARNING = 2  # Warning conditions
INFO    = 3  # Informational messages
DEBUG   = 4  # Debug-level messages
TRACE   = 5  # Detailed trace messages
```

### 10. **Complete Enable Script**

Create a script `/usr/local/bin/enable-tr181-zones.sh`:

```bash
#!/bin/sh

# Enable all tr181-httpprocess logging zones

# Set environment variables
export AMXRT_LOG_ZONES="session,dm,dm_userintf,config,main"
export AMXRT_LOG_LEVEL="DEBUG"
export AMXRT_LOG_FACILITY="local0"

# Enable individual zones
export AMXRT_LOG_ZONE_SESSION=1
export AMXRT_LOG_ZONE_DM=1
export AMXRT_LOG_ZONE_DM_USERINTF=1
export AMXRT_LOG_ZONE_CONFIG=1
export AMXRT_LOG_ZONE_MAIN=1

# Create log directory
mkdir -p /var/log/tr181

# Configure syslog
cat > /etc/rsyslog.d/60-tr181.conf << EOF
# TR181 HTTP Process Zone Logging
local0.*    /var/log/tr181/all.log

# Zone-specific logging
:msg, contains, "ZONE:session"     /var/log/tr181/session.log
:msg, contains, "ZONE:dm"          /var/log/tr181/dm.log
:msg, contains, "ZONE:dm_userintf" /var/log/tr181/dm_userintf.log
:msg, contains, "ZONE:config"      /var/log/tr181/config.log
:msg, contains, "ZONE:main"        /var/log/tr181/main.log

& stop
EOF

# Restart services
systemctl restart rsyslog
systemctl restart tr181-httpprocess

echo "TR181 zone logging enabled. Check /var/log/tr181/"
```

### 11. **Troubleshooting Tips**

```bash
# Check if tr181-httpprocess is running
ps aux | grep tr181-httpprocess

# Check process environment
cat /proc/$(pidof tr181-httpprocess)/environ | tr '\0' '\n' | grep LOG

# Verify library support
strings /usr/lib/libamxrt.so | grep -i zone

# Check configuration files
find /etc -name "*tr181*" -o -name "*ambiorix*" 2>/dev/null

# Test zone logging
echo "test:session:debug:Test session message" > /dev/log
echo "test:dm:debug:Test DM message" > /dev/log
```

### Important Notes:

1. **Version Dependency**: The exact commands may vary based on your tr181-httpprocess version
2. **Persistence**: Environment variables need to be set in service files for persistence across reboots
3. **Performance Impact**: Enabling all zones with DEBUG level can impact performance
4. **Log Rotation**: Configure log rotation to prevent disk space issues
5. **Security**: Ensure log files don't contain sensitive information

### Quick Enable All Zones:

```bash
# One-liner to enable all zones
export AMXRT_LOG_ZONES="session,dm,dm_userintf,config,main" && \
export AMXRT_LOG_LEVEL=DEBUG && \
systemctl restart tr181-httpprocess && \
tail -f /var/log/syslog | grep -E "session|dm|config|main"
```

This comprehensive guide should help you enable and manage zone-based logging for the tr181-httpprocess package in prplOS. The exact implementation may vary slightly based on your specific version and configuration.
