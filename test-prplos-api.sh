#!/bin/bash

# Configuration
DEVICE_IP="192.168.1.1"
BASE_URL="http://$DEVICE_IP"

echo "🚀 Testing prplOS API on $DEVICE_IP"
echo "===================================="

# Step 1: Authenticate
echo -e "\n1️⃣ Authenticating..."
SESSION_RESPONSE=$(curl -s -X POST "$BASE_URL/session" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}')

# Extract sessionID (with capital ID!)
SESSION_ID=$(echo $SESSION_RESPONSE | grep -o '"sessionID":"[^"]*' | cut -d'"' -f4)

if [ -z "$SESSION_ID" ]; then
    echo "❌ Failed to get session ID"
    echo "Response was: $SESSION_RESPONSE"
    exit 1
else
    echo "✅ Got session: $SESSION_ID"
fi

# Step 2: Test non-protected endpoint (if any)
echo -e "\n2️⃣ Testing device info endpoint..."
RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" \
  "$BASE_URL/serviceElements/Device.DeviceInfo.ModelName" \
  -H "Authorization: bearer $SESSION_ID" \
  -H "Content-Type: application/json")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")

echo "Response Code: $HTTP_CODE"
echo "Response Body: $BODY"

# Step 3: Test with proper TR-181 format
echo -e "\n3️⃣ Testing TR-181 parameter access..."
RESPONSE=$(curl -v "$BASE_URL/serviceElements/Device.DeviceInfo.ModelName" \
  -H "Authorization: bearer $SESSION_ID" \
  -H "Content-Type: application/json")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")

echo "Response Code: $HTTP_CODE"
echo "Response Body: $BODY"


# Step 4: Test specific parameter
echo -e "\n4️⃣ Testing specific parameter..."
RESPONSE=$(curl -v "$BASE_URL/serviceElements/Device.WiFi.SSID.1.SSID" \
  -H "Authorization: bearer $SESSION_ID" \
  -H "Content-Type: application/json")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")

echo "Response Code: $HTTP_CODE"
echo "Response Body: $BODY"

# Step 5: Test specific parameter
echo -e "\n5. Testing specific parameter..."
RESPONSE=$(curl -v "$BASE_URL/serviceElements/Device.WiFi.SSID.2.SSID" \
  -H "Authorization: bearer $SESSION_ID" \
  -H "Content-Type: application/json")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")

echo "Response Code: $HTTP_CODE"
echo "Response Body: $BODY"

# Step 6: Test specific OBJECT BULK GET parameter
echo -e "\6. Testing specific OBJECT BULK GET parameter..."
RESPONSE=$(curl -v "$BASE_URL/serviceElements/Device.WiFi.SSID." \
  -H "Authorization: bearer $SESSION_ID" \
  -H "Content-Type: application/json")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")

echo "Response Code: $HTTP_CODE"
echo "Response Body: $BODY"

# Step 7: Test specific OBJECT BULK GET RADIO parameter
echo -e "\7. Testing specific OBJECT BULK GET RADIO parameter..."
RESPONSE=$(curl -v "$BASE_URL/serviceElements/Device.WiFi.Radio." \
  -H "Authorization: bearer $SESSION_ID" \
  -H "Content-Type: application/json")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")

echo "Response Code: $HTTP_CODE"
echo "Response Body: $BODY"



# Step FINAL: Test with proper TR-181 format
echo -e "\n3️⃣ Testing TR-181 BULK parameter access..."
RESPONSE=$(curl -v "$BASE_URL/serviceElements/Device.DeviceInfo." \
  -H "Authorization: bearer $SESSION_ID" \
  -H "Content-Type: application/json")

HTTP_CODE=$(echo "$RESPONSE" | grep "HTTP_CODE:" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | grep -v "HTTP_CODE:")

echo "Response Code: $HTTP_CODE"
echo "Response Body: $BODY"
