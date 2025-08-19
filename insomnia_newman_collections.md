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