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


I'll help you trace the function flow for a TR-069/CWMP implementation, specifically for the DeviceInfo.ModelName parameter. Here's a comprehensive guide on how to manually trace the end-to-end flow:

## 1. **Understanding the Architecture First**

Before tracing, understand the typical TR-069 architecture:
- **ACS (Auto Configuration Server)** sends requests
- **CPE (Customer Premises Equipment)** receives and processes requests
- **Data Model (DM)** layer handles parameter get/set operations
- **Backend modules** (.c files) implement actual parameter handlers

## 2. **Tools for Manual Tracing**

```bash
# Key tools for tracing:
grep -r "DeviceInfo" .              # Find all DeviceInfo references
grep -r "ModelName" .                # Find ModelName references
find . -name "*.c" -o -name "*.h"   # List all C source/header files
ctags -R .                           # Generate tags for navigation
cscope -R                            # Build cscope database
```

## 3. **Example Flow for DeviceInfo.ModelName**

Here's a typical end-to-end flow:

### **Step 1: Endpoint Request (HTTP/SOAP)**
```xml
<!-- Incoming GetParameterValues request -->
<soap:Envelope>
  <soap:Body>
    <cwmp:GetParameterValues>
      <ParameterNames>
        <string>Device.DeviceInfo.ModelName</string>
      </ParameterNames>
    </cwmp:GetParameterValues>
  </soap:Body>
</soap:Envelope>
```

### **Step 2: Request Parser**
Look for files handling SOAP parsing:
```c
// Typically in files like: cwmp_handler.c, soap_parser.c
void handle_get_parameter_values(soap_request *req) {
    // Parse parameter names
    char *param_name = parse_parameter_name(req);  // "Device.DeviceInfo.ModelName"
    
    // Route to parameter handler
    dm_result = dm_get_parameter(param_name);
}
```

### **Step 3: Data Model Router**
Find the DM routing logic:
```c
// Usually in: dm_handler.c, parameter_manager.c
dm_value* dm_get_parameter(char *param_path) {
    // Parse the path: Device.DeviceInfo.ModelName
    object_path = parse_object_path(param_path);  // "Device.DeviceInfo"
    param_name = parse_param_name(param_path);    // "ModelName"
    
    // Find handler for this object
    handler = find_object_handler(object_path);
    return handler->get_param(param_name);
}
```

### **Step 4: Object Handler Registration**
Look for registration tables:
```c
// In files like: device_info.c, dm_objects.c
static dm_object_handler device_info_handler = {
    .object_path = "Device.DeviceInfo",
    .get_param = device_info_get_param,
    .set_param = device_info_set_param,
    .parameters = {
        {"ModelName", get_model_name, NULL, DM_STRING},
        {"Manufacturer", get_manufacturer, NULL, DM_STRING},
        // ... other parameters
    }
};
```

### **Step 5: Actual Parameter Implementation**
Find the implementation:
```c
// In device_info.c or similar
char* get_model_name(void) {
    static char model_name[64];
    
    // Method 1: Read from system file
    FILE *fp = fopen("/etc/device_model", "r");
    if (fp) {
        fgets(model_name, sizeof(model_name), fp);
        fclose(fp);
    }
    
    // Method 2: Read from hardware info
    // get_hardware_info(model_name, sizeof(model_name));
    
    // Method 3: Hardcoded or from config
    // strcpy(model_name, DEVICE_MODEL_NAME);
    
    return model_name;
}
```

### **Step 6: Response Building**
```c
// In response_builder.c or cwmp_response.c
soap_response* build_get_parameter_response(dm_results *results) {
    soap_response *resp = create_soap_response();
    
    // Add parameter values to response
    for (each result) {
        add_parameter_value(resp, 
            "Device.DeviceInfo.ModelName", 
            "RouterModel-X100",  // The actual value
            "xsd:string");
    }
    
    return resp;
}
```

### **Step 7: HTTP Response**
```xml
<!-- Outgoing response -->
HTTP/1.1 200 OK
Content-Type: text/xml; charset=utf-8

<soap:Envelope>
  <soap:Body>
    <cwmp:GetParameterValuesResponse>
      <ParameterList>
        <ParameterValueStruct>
          <Name>Device.DeviceInfo.ModelName</Name>
          <Value xsi:type="xsd:string">RouterModel-X100</Value>
        </ParameterValueStruct>
      </ParameterList>
    </cwmp:GetParameterValuesResponse>
  </soap:Body>
</soap:Envelope>
```

## 4. **Manual Tracing Steps**

### **A. Start from Entry Point:**
```bash
# Find main entry points
grep -r "main(" *.c
grep -r "handle_request\|process_request" *.c
grep -r "soap.*parse\|parse.*soap" *.c
```

### **B. Trace Parameter Path:**
```bash
# Find where DeviceInfo is handled
grep -r "DeviceInfo" --include="*.c"
grep -r "\"ModelName\"" --include="*.c"
grep -r "Device\.DeviceInfo" --include="*.c"
```

### **C. Find Registration Points:**
```bash
# Look for object/parameter registration
grep -r "register.*object\|object.*register" *.c
grep -r "parameter.*table\|param.*list" *.c
grep -r "handler.*table" *.c
```

### **D. Locate Implementation:**
```bash
# Find actual implementation
grep -r "get.*model.*name\|model.*name.*get" *.c
grep -r "MODEL_NAME\|model_name" *.h
```

## 5. **Creating a Function Call Graph**

Create a visual flow diagram:

```
[HTTP Request] 
    ↓
[cwmp_main.c: handle_http_request()]
    ↓
[soap_parser.c: parse_soap_envelope()]
    ↓
[cwmp_handler.c: process_cwmp_message()]
    ↓
[cwmp_handler.c: handle_get_parameter_values()]
    ↓
[dm_manager.c: dm_get_parameter("Device.DeviceInfo.ModelName")]
    ↓
[dm_router.c: route_to_handler()]
    ↓
[device_info.c: device_info_get_param("ModelName")]
    ↓
[device_info.c: get_model_name()]
    ↓
[response_builder.c: build_parameter_response()]
    ↓
[http_response.c: send_http_response(200, soap_body)]
```

## 6. **Debug Tracing Techniques**

Add debug prints to trace the actual flow:

```c
// Add these to trace execution
#define TRACE_FLOW(func) printf("[FLOW] %s:%d - %s()\n", __FILE__, __LINE__, func)

// In each function:
void device_info_get_param(char *param) {
    TRACE_FLOW(__FUNCTION__);
    printf("  Getting parameter: %s\n", param);
    // ... rest of code
}
```

## 7. **Common File Patterns to Look For**

```bash
# Key files in typical TR-069 implementations:
*cwmp*.c         # CWMP protocol handlers
*soap*.c         # SOAP message processing
*dm*.c           # Data model handlers
*parameter*.c    # Parameter management
*device_info*.c  # DeviceInfo object implementation
*handler*.c      # Request handlers
*router*.c       # Request routing
```

## 8. **Quick Tracing Script**

Create a script to help trace:

```bash
#!/bin/bash
# trace_flow.sh

PARAM="Device.DeviceInfo.ModelName"
echo "Tracing flow for: $PARAM"

echo -e "\n1. Entry points:"
grep -l "main\|handle_request" *.c

echo -e "\n2. SOAP/CWMP handlers:"
grep -l "GetParameterValues" *.c

echo -e "\n3. Parameter routing:"
grep -l "DeviceInfo" *.c | xargs grep -l "ModelName"

echo -e "\n4. Implementation files:"
grep -l "model_name\|MODEL_NAME" *.c

echo -e "\n5. Function calls containing 'DeviceInfo':"
grep -n "DeviceInfo" *.c | grep "("
```

This comprehensive guide should help you trace the complete flow from endpoint request to response. Start with the entry point and follow the function calls step by step, using grep and other tools to locate each component in the chain.
