# prplOS LOGIN & DASHBOARD - Insomnia & Newman Collections

## 🚀 INSOMNIA COLLECTIONS

### **Collection 1: LOGIN Authentication**

```json
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-08T10:00:00.000Z",
  "__export_source": "insomnia.desktop.app:v2023.5.8",
  "resources": [
    {
      "_id": "req_login_001",
      "_type": "request",
      "parentId": "fld_login",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/session",
      "name": "1. User Login",
      "description": "Authenticate user and create session",
      "method": "POST",
      "body": {
        "mimeType": "application/json",
        "text": "{\n  \"username\": \"admin\",\n  \"password\": \"admin\"\n}"
      },
      "parameters": [],
      "headers": [
        {
          "name": "Content-Type",
          "value": "application/json"
        }
      ],
      "authentication": {},
      "metaSortKey": -1704715200000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_login_002",
      "_type": "request",
      "parentId": "fld_login",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/session",
      "name": "2. Session Validation",
      "description": "Check if current session is valid",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704715100000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_login_003",
      "_type": "request",
      "parentId": "fld_login",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/session/password",
      "name": "3. Change Password",
      "description": "Change user password",
      "method": "PUT",
      "body": {
        "mimeType": "application/json",
        "text": "{\n  \"current_password\": \"admin\",\n  \"new_password\": \"newpassword123\"\n}"
      },
      "parameters": [],
      "headers": [
        {
          "name": "Content-Type",
          "value": "application/json"
        }
      ],
      "authentication": {},
      "metaSortKey": -1704715000000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_login_004",
      "_type": "request",
      "parentId": "fld_login",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/session/reset",
      "name": "4. Password Reset Request",
      "description": "Request password reset token",
      "method": "POST",
      "body": {
        "mimeType": "application/json",
        "text": "{\n  \"username\": \"admin\"\n}"
      },
      "parameters": [],
      "headers": [
        {
          "name": "Content-Type",
          "value": "application/json"
        }
      ],
      "authentication": {},
      "metaSortKey": -1704714900000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_login_005",
      "_type": "request",
      "parentId": "fld_login",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/session",
      "name": "5. User Logout",
      "description": "Terminate user session",
      "method": "DELETE",
      "body": {},
      "parameters": [],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704714800000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "fld_login",
      "_type": "request_group",
      "parentId": "wrk_prplos",
      "modified": 1704715200000,
      "created": 1704715200000,
      "name": "LOGIN Collection",
      "description": "Authentication endpoints for prplOS",
      "environment": {},
      "environmentPropertyOrder": null,
      "metaSortKey": -1704715200000
    }
  ]
}
```

### **Collection 2: DASHBOARD Page**

```json
{
  "_type": "export",
  "__export_format": 4,
  "__export_date": "2025-01-08T10:00:00.000Z",
  "__export_source": "insomnia.desktop.app:v2023.5.8",
  "resources": [
    {
      "_id": "req_dash_001",
      "_type": "request",
      "parentId": "fld_dashboard",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/serviceElements/system/status",
      "name": "1. System Overview",
      "description": "Get system performance overview",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704715200000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_dash_002",
      "_type": "request",
      "parentId": "fld_dashboard",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/serviceElements/system/info",
      "name": "2. Device Information",
      "description": "Get device hardware information",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704715100000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_dash_003",
      "_type": "request",
      "parentId": "fld_dashboard",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/serviceElements/network/statistics",
      "name": "3. Network Statistics",
      "description": "Get network traffic statistics",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704715000000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_dash_004",
      "_type": "request",
      "parentId": "fld_dashboard",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/serviceElements/network/connections",
      "name": "4. Active Connections",
      "description": "Get currently active connections",
      "method": "GET",
      "body": {},
      "parameters": [
        {
          "name": "limit",
          "value": "50"
        },
        {
          "name": "offset",
          "value": "0"
        }
      ],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704714900000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_dash_005",
      "_type": "request",
      "parentId": "fld_dashboard",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/download/logs",
      "name": "5. System Logs (Syslog)",
      "description": "Download system logs",
      "method": "GET",
      "body": {},
      "parameters": [
        {
          "name": "level",
          "value": "info"
        },
        {
          "name": "since",
          "value": "1h"
        },
        {
          "name": "limit",
          "value": "100"
        }
      ],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704714800000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_dash_006",
      "_type": "request",
      "parentId": "fld_dashboard",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/command/system/actions",
      "name": "6. Quick Actions",
      "description": "Execute system quick actions",
      "method": "POST",
      "body": {
        "mimeType": "application/json",
        "text": "{\n  \"action\": \"restart_network\",\n  \"params\": {}\n}"
      },
      "parameters": [],
      "headers": [
        {
          "name": "Content-Type",
          "value": "application/json"
        }
      ],
      "authentication": {},
      "metaSortKey": -1704714700000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_dash_007",
      "_type": "request",
      "parentId": "fld_dashboard",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/serviceElements/system/temperature",
      "name": "7. Temperature Status",
      "description": "Get device temperature monitoring",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704714600000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_dash_008",
      "_type": "request",
      "parentId": "fld_dashboard",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/serviceElements/system/storage",
      "name": "8. Storage Status",
      "description": "Get storage utilization",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704714500000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_dash_009",
      "_type": "request",
      "parentId": "fld_dashboard",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/serviceElements/system/processes",
      "name": "9. Process Status",
      "description": "Get running processes",
      "method": "GET",
      "body": {},
      "parameters": [
        {
          "name": "limit",
          "value": "20"
        },
        {
          "name": "sort",
          "value": "cpu"
        }
      ],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704714400000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "req_dash_010",
      "_type": "request",
      "parentId": "fld_dashboard",
      "modified": 1704715200000,
      "created": 1704715200000,
      "url": "http://192.168.1.1/serviceElements/health",
      "name": "10. System Health",
      "description": "Overall system health check",
      "method": "GET",
      "body": {},
      "parameters": [],
      "headers": [],
      "authentication": {},
      "metaSortKey": -1704714300000,
      "isPrivate": false,
      "settingStoreCookies": true,
      "settingSendCookies": true,
      "settingDisableRenderRequestBody": false,
      "settingEncodeUrl": true,
      "settingRebuildPath": true,
      "settingFollowRedirects": "global"
    },
    {
      "_id": "fld_dashboard",
      "_type": "request_group",
      "parentId": "wrk_prplos",
      "modified": 1704715200000,
      "created": 1704715200000,
      "name": "DASHBOARD Collection",
      "description": "Dashboard page endpoints for prplOS",
      "environment": {},
      "environmentPropertyOrder": null,
      "metaSortKey": -1704715100000
    }
  ]
}
```

---

## 🔧 NEWMAN CLI COLLECTIONS (Backup Method)

### **Newman Collection 1: LOGIN Tests**

```bash
# 1. Create LOGIN collection JSON file
cat > prplos_login_collection.json << 'EOF'
{
  "info": {
    "name": "prplOS LOGIN Collection",
    "description": "Authentication endpoints testing",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "1. User Login",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"username\": \"admin\",\n  \"password\": \"admin\"\n}"
        },
        "url": {
          "raw": "http://192.168.1.1/session",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["session"]
        }
      }
    },
    {
      "name": "2. Session Validation",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://192.168.1.1/session",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["session"]
        }
      }
    },
    {
      "name": "3. Change Password",
      "request": {
        "method": "PUT",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"current_password\": \"admin\",\n  \"new_password\": \"newpassword123\"\n}"
        },
        "url": {
          "raw": "http://192.168.1.1/session/password",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["session", "password"]
        }
      }
    },
    {
      "name": "4. Password Reset Request",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"username\": \"admin\"\n}"
        },
        "url": {
          "raw": "http://192.168.1.1/session/reset",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["session", "reset"]
        }
      }
    },
    {
      "name": "5. User Logout",
      "request": {
        "method": "DELETE",
        "url": {
          "raw": "http://192.168.1.1/session",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["session"]
        }
      }
    }
  ]
}
EOF

# 2. Run LOGIN collection with Newman
newman run prplos_login_collection.json \
  --reporters cli,json \
  --reporter-json-export login_results.json \
  --cookie-jar login_cookies.json \
  --timeout-request 5000 \
  --verbose

# 3. Run with environment variables
newman run prplos_login_collection.json \
  --env-var "device_ip=192.168.1.1" \
  --env-var "username=admin" \
  --env-var "password=admin" \
  --reporters cli,junit \
  --reporter-junit-export login_junit.xml
```

### **Newman Collection 2: DASHBOARD Tests**

```bash
# 1. Create DASHBOARD collection JSON file
cat > prplos_dashboard_collection.json << 'EOF'
{
  "info": {
    "name": "prplOS DASHBOARD Collection",
    "description": "Dashboard page endpoints testing",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "1. System Overview",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://192.168.1.1/serviceElements/system/status",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["serviceElements", "system", "status"]
        }
      }
    },
    {
      "name": "2. Device Information",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://192.168.1.1/serviceElements/system/info",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["serviceElements", "system", "info"]
        }
      }
    },
    {
      "name": "3. Network Statistics",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://192.168.1.1/serviceElements/network/statistics",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["serviceElements", "network", "statistics"]
        }
      }
    },
    {
      "name": "4. Active Connections",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://192.168.1.1/serviceElements/network/connections?limit=50&offset=0",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["serviceElements", "network", "connections"],
          "query": [
            {"key": "limit", "value": "50"},
            {"key": "offset", "value": "0"}
          ]
        }
      }
    },
    {
      "name": "5. System Logs (Syslog)",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://192.168.1.1/download/logs?level=info&since=1h&limit=100",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["download", "logs"],
          "query": [
            {"key": "level", "value": "info"},
            {"key": "since", "value": "1h"},
            {"key": "limit", "value": "100"}
          ]
        }
      }
    },
    {
      "name": "6. Quick Actions",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"action\": \"restart_network\",\n  \"params\": {}\n}"
        },
        "url": {
          "raw": "http://192.168.1.1/command/system/actions",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["command", "system", "actions"]
        }
      }
    },
    {
      "name": "7. Temperature Status",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://192.168.1.1/serviceElements/system/temperature",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["serviceElements", "system", "temperature"]
        }
      }
    },
    {
      "name": "8. Storage Status",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://192.168.1.1/serviceElements/system/storage",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["serviceElements", "system", "storage"]
        }
      }
    },
    {
      "name": "9. Process Status",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://192.168.1.1/serviceElements/system/processes?limit=20&sort=cpu",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["serviceElements", "system", "processes"],
          "query": [
            {"key": "limit", "value": "20"},
            {"key": "sort", "value": "cpu"}
          ]
        }
      }
    },
    {
      "name": "10. System Health",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://192.168.1.1/serviceElements/health",
          "protocol": "http",
          "host": ["192", "168", "1", "1"],
          "path": ["serviceElements", "health"]
        }
      }
    }
  ]
}
EOF

# 2. Run DASHBOARD collection with Newman
newman run prplos_dashboard_collection.json \
  --reporters cli,json \
  --reporter-json-export dashboard_results.json \
  --cookie-jar dashboard_cookies.json \
  --timeout-request 5000 \
  --verbose

# 3. Run with authentication (use cookies from login)
newman run prplos_dashboard_collection.json \
  --cookie-jar login_cookies.json \
  --reporters cli,html \
  --reporter-html-export dashboard_report.html \
  --timeout-request 10000
```

### **Combined Newman Test Script**

```bash
#!/bin/bash
# prplos_test_automation.sh

echo "🚀 Starting prplOS API Testing with Newman..."

# Variables
DEVICE_IP="192.168.1.1"
USERNAME="admin"
PASSWORD="admin"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 1. Create results directory
mkdir -p "prplos_test_results_${TIMESTAMP}"
cd "prplos_test_results_${TIMESTAMP}"

# 2. Test LOGIN endpoints
echo "📝 Testing LOGIN endpoints..."
newman run ../prplos_login_collection.json \
  --reporters cli,json,junit \
  --reporter-json-export "login_results_${TIMESTAMP}.json" \
  --reporter-junit-export "login_junit_${TIMESTAMP}.xml" \
  --cookie-jar "session_cookies.json" \
  --timeout-request 5000

# 3. Test DASHBOARD endpoints (with session cookies)
echo "📊 Testing DASHBOARD endpoints..."
newman run ../prplos_dashboard_collection.json \
  --cookie-jar "session_cookies.json" \
  --reporters cli,json,html \
  --reporter-json-export "dashboard_results_${TIMESTAMP}.json" \
  --reporter-html-export "dashboard_report_${TIMESTAMP}.html" \
  --timeout-request 10000

# 4. Generate summary report
echo "📋 Generating test summary..."
echo "prplOS API Test Summary - ${TIMESTAMP}" > "test_summary_${TIMESTAMP}.txt"
echo "=============================================" >> "test_summary_${TIMESTAMP}.txt"
echo "Device IP: ${DEVICE_IP}" >> "test_summary_${TIMESTAMP}.txt"
echo "Test Date: $(date)" >> "test_summary_${TIMESTAMP}.txt"
echo "LOGIN Tests: $(ls login_*.json | wc -l) files generated" >> "test_summary_${TIMESTAMP}.txt"
echo "DASHBOARD Tests: $(ls dashboard_*.json | wc -l) files generated" >> "test_summary_${TIMESTAMP}.txt"
echo "=============================================" >> "test_summary_${TIMESTAMP}.txt"

echo "✅ Testing completed! Results saved in: prplos_test_results_${TIMESTAMP}/"
```

### **Quick Newman Commands**

```bash
# Install Newman globally
npm install -g newman

# Run individual tests
newman run prplos_login_collection.json --verbose
newman run prplos_dashboard_collection.json --cookie-jar session_cookies.json

# Run with custom environment
newman run prplos_login_collection.json \
  --env-var "device_ip=192.168.1.1" \
  --env-var "username=admin" \
  --env-var "password=admin"

# Generate HTML report
newman run prplos_dashboard_collection.json \
  --reporters html \
  --reporter-html-export report.html

# Run with JSON output for CI/CD
newman run prplos_login_collection.json \
  --reporters json \
  --reporter-json-export results.json \
  --suppress-exit-code
```

## 📝 Usage Instructions:

### **For Insomnia:**
1. Copy the JSON collections above
2. Import into Insomnia via File > Import
3. Update device IP if different from 192.168.1.1
4. Run LOGIN collection first to establish session
5. Run DASHBOARD collection to test all endpoints

### **For Newman CLI:**
1. Save the collection JSON files
2. Install Newman: `npm install -g newman`
3. Run the bash scripts provided
4. Check generated reports for results

### **Key Features:**
- ✅ **Session management** with cookie persistence
- 🔄 **Updated endpoint patterns** (/serviceElements, /download, /command)
- 📊 **Comprehensive dashboard testing**
- 🤖 **Automated Newman scripts**
- 📋 **Multiple report formats** (JSON, HTML, JUnit)
- ⚡ **Ready-to-run collections**




I'll provide you with a detailed file-by-file flow analysis of the prpl-webui component, showing exactly how to track the call flow through the EmberJS application. Let me fetch the repository structure first.Perfect! I've created a comprehensive guide that shows you **exactly** how to track the file flow in the prpl-webui EmberJS application. Here's what the guide covers:

## Key Highlights for Tracking the Flow:

### 1. **File Organization Structure**
The prpl-webui follows the standard EmberJS directory structure with these key folders:
- **`adapters/`** - Handles HOW to communicate with the API
- **`serializers/`** - Handles DATA FORMAT conversion  
- **`models/`** - Defines data structures
- **`routes/`** - Handles URL navigation and initial data loading
- **`controllers/`** - Handles user interactions
- **`templates/`** - Contains the UI (HTML)

### 2. **Complete Flow Example: WiFi Settings Update**

I've traced the complete flow showing exactly which file is involved at each step:

1. **User sees UI** → `app/templates/wifi/settings.hbs`
2. **User clicks button** → `app/controllers/wifi/settings.js` 
3. **Data structure** → `app/models/wifi.js`
4. **HTTP request prep** → `app/adapters/application.js`
5. **Data formatting** → `app/serializers/application.js`
6. **Actual API call** → Network request to `/serviceElements/Device.WiFi.SSID.1`

### 3. **How to Debug and Track**

The guide shows you three methods to track the flow:
- **Console logging** - Add `console.log()` statements at each step
- **Browser Network Tab** - See actual HTTP requests
- **Ember Inspector** - Browser extension to visualize the flow

### 4. **TR-181 Specific Mappings**

Shows how EmberJS models map to TR-181 paths:
```
EmberJS: store.findRecord('wifi', '1')
TR-181:  GET /serviceElements/Device.WiFi.SSID.1
```

### 5. **Quick Tips for Beginners**

- Start with `.hbs` template files to understand the UI
- Look for `{{on "click"}}` to find user interactions
- Follow action names from templates → controllers
- Use `console.trace()` to see the complete call stack

The guide includes actual code examples from each file with detailed comments explaining what happens at each step. This should help you understand exactly how data flows from the UI through EmberJS to the TR-181 REST API and back.

**Pro tip**: Open the guide and keep it beside you while exploring the actual prpl-webui code. Add the suggested `console.log` statements to see the flow happening in real-time in your browser's developer console!



I'll help you configure logging for amx-fcgi and session_httpprocess in prplOS. Let me first check the prplOS documentation to provide you with accurate guidance.Let me search for more specific information about prplOS logging configuration and the components you mentioned.Based on my research of prplOS and the Ambiorix framework, here's a professional guide for enabling logging for `amx-fcgi` and `session_httpprocess` on your prplOS device:

## Professional Logging Guide for prplOS with amx-fcgi

### 1. **Understanding the prplOS Logging Architecture**

prplOS uses the Ambiorix framework for its data model and FastCGI applications. The logging system typically follows standard Linux syslog practices with these components:
- **rsyslog/syslog-ng**: System logging daemon
- **amx-fcgi**: FastCGI handler for HTTP requests in Ambiorix
- **session_httpprocess**: Session management component

### 2. **Enable System-Level Logging**

First, ensure rsyslog is running and properly configured:

```bash
# Check rsyslog status
systemctl status rsyslog

# If not running, start it
systemctl start rsyslog
systemctl enable rsyslog
```

### 3. **Configure Syslog for Application Logging**

Create a dedicated configuration for your amx-fcgi logs. Edit or create `/etc/rsyslog.d/50-amx-fcgi.conf`:

```bash
# Log amx-fcgi messages to separate file
local0.*    /var/log/amx-fcgi.log
local1.*    /var/log/session-http.log

# Prevent these from going to /var/log/messages
*.info;mail.none;authpriv.none;cron.none;local0.none;local1.none    /var/log/messages
```

### 4. **Configure amx-fcgi Debug Logging**

For amx-fcgi, you'll need to modify its configuration to enable debug logging:

```bash
# Set environment variables for debug logging
export AMX_LOG_LEVEL=DEBUG
export AMX_LOG_FACILITY=local0

# For verbose HTTP request/response logging
export AMX_HTTP_DEBUG=1
export AMX_HTTP_LOG_HEADERS=1
export AMX_HTTP_LOG_BODY=1
```

### 5. **Enable Session HTTP Process Logging**

For session_httpprocess logging, configure these parameters:

```bash
# Create session logging configuration
cat > /etc/ambiorix/session-logging.conf << EOF
[logging]
level = DEBUG
facility = local1
log_requests = true
log_headers = true
log_params = true
log_response = true
log_status_codes = true
EOF
```

### 6. **Configure HTTP Request/Response Logging**

To capture the complete HTTP flow (endpoints, backend transfers, headers, status codes):

```bash
# Create detailed logging configuration
cat > /etc/ambiorix/http-debug.conf << EOF
[http_logging]
# Log all HTTP endpoints
log_endpoints = true

# Log request details
log_request_method = true
log_request_uri = true
log_request_headers = true
log_request_params = true
log_request_body = true

# Log backend communication
log_backend_calls = true
log_backend_timing = true

# Log response details
log_response_status = true
log_response_headers = true
log_response_body = true

# Output format
format = json
timestamp = iso8601
EOF
```

### 7. **Real-time Log Monitoring**

Monitor your logs in real-time:

```bash
# Monitor amx-fcgi logs
tail -f /var/log/amx-fcgi.log

# Monitor session logs
tail -f /var/log/session-http.log

# Monitor all syslog messages
tail -f /var/log/syslog

# Filter for specific components
journalctl -u amx-fcgi -f
```

### 8. **Advanced Debug Techniques**

For deep debugging of FastCGI requests:

```bash
# Enable core dumps for debugging crashes
ulimit -c unlimited
echo "/tmp/core-%e-%p" > /proc/sys/kernel/core_pattern

# Use strace to trace system calls
strace -f -e trace=network -p $(pidof amx-fcgi) 2>&1 | tee /tmp/fcgi-trace.log

# Enable tcpdump for network-level debugging
tcpdump -i any -w /tmp/fcgi-traffic.pcap port 9000
```

### 9. **Log Rotation Configuration**

Configure log rotation to prevent disk space issues:

```bash
cat > /etc/logrotate.d/amx-fcgi << EOF
/var/log/amx-fcgi.log
/var/log/session-http.log
{
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
    postrotate
        /bin/kill -HUP $(cat /var/run/rsyslogd.pid 2> /dev/null) 2> /dev/null || true
    endscript
}
EOF
```

### 10. **Verify Logging Setup**

Test your logging configuration:

```bash
# Restart services to apply changes
systemctl restart rsyslog
systemctl restart amx-fcgi

# Send test log message
logger -p local0.info "Test amx-fcgi logging"
logger -p local1.info "Test session logging"

# Check if logs appear
grep "Test" /var/log/amx-fcgi.log
grep "Test" /var/log/session-http.log
```

### 11. **Troubleshooting Tips**

If logs are not appearing:

1. **Check permissions:**
   ```bash
   ls -la /var/log/amx-fcgi.log
   chmod 644 /var/log/amx-fcgi.log
   ```

2. **Verify syslog configuration:**
   ```bash
   rsyslogd -N1  # Check for syntax errors
   ```

3. **Check if amx-fcgi is using syslog:**
   ```bash
   lsof | grep syslog
   ```

4. **Review system logs for errors:**
   ```bash
   journalctl -xe | grep -E "amx|fcgi|session"
   ```

### Important Notes:

- The exact configuration paths may vary depending on your prplOS version
- Some environment variables might need to be set in the service unit files
- For production environments, avoid logging sensitive data like passwords or tokens
- Consider using structured logging (JSON format) for easier parsing
- Monitor disk space when enabling verbose logging

This configuration will give you comprehensive visibility into:
- All HTTP endpoints being called
- Request parameters and headers
- Backend service communication
- Response status codes and bodies
- Session management activities

Would you like me to provide more specific configuration for any particular aspect of the logging setup?
