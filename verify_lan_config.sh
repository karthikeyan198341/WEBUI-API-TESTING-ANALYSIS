#!/bin/bash
# verify_lan_config.sh - Verify LAN configuration state

DEVICE_IP="192.168.1.1"
BASE_URL="http://${DEVICE_IP}:8080"
USERNAME="admin"
PASSWORD="admin"

echo "=== LAN Configuration Verification ==="

# Get current IP configuration
echo "Current LAN IP Configuration:"
curl -s -X POST "${BASE_URL}/serviceElements" \
     -H "Content-Type: application/json" \
     -H "Authorization: Basic $(echo -n "${USERNAME}:${PASSWORD}" | base64)" \
     -d '{
         "jsonrpc": "2.0",
         "method": "get",
         "params": {
             "path": "Device.IP.Interface.3.IPv4Address.1."
         },
         "id": "verify_ip"
     }' | jq .

echo ""
echo "Current DHCP Configuration:"
curl -s -X POST "${BASE_URL}/serviceElements" \
     -H "Content-Type: application/json" \
     -H "Authorization: Basic $(echo -n "${USERNAME}:${PASSWORD}" | base64)" \
     -d '{
         "jsonrpc": "2.0",
         "method": "get",
         "params": {
             "path": "Device.DHCPv4.Server."
         },
         "id": "verify_dhcp"
     }' | jq .
