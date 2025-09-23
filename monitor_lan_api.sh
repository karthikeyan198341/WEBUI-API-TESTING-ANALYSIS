#!/bin/bash
# monitor_lan_api.sh - Monitor LAN API performance

DEVICE_IP="192.168.1.1"
BASE_URL="http://${DEVICE_IP}:8080"
USERNAME="admin"
PASSWORD="admin"
INTERVAL=5
COUNT=10

echo "=== LAN API Performance Monitor ==="
echo "Monitoring $BASE_URL every ${INTERVAL}s for ${COUNT} iterations"

for i in $(seq 1 $COUNT); do
    echo "Iteration $i/$(COUNT):"
    
    start_time=$(date +%s.%N)
    
    response=$(curl -s -w "%{http_code}" \
                   -X POST "${BASE_URL}/serviceElements" \
                   -H "Content-Type: application/json" \
                   -H "Authorization: Basic $(echo -n "${USERNAME}:${PASSWORD}" | base64)" \
                   -d '{
                       "jsonrpc": "2.0",
                       "method": "get",
                       "params": {
                           "path": "Device.IP.Interface.3.IPv4Address.1.IPAddress"
                       },
                       "id": "monitor_'$i'"
                   }')
    
    end_time=$(date +%s.%N)
    duration=$(echo "$end_time - $start_time" | bc -l)
    
    echo "  Response time: ${duration}s"
    echo "  HTTP Status: $(echo "$response" | tail -c 4)"
    
    sleep $INTERVAL
done
