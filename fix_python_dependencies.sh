#!/bin/bash

# Fix Python Dependencies for PRPLOS Testing Framework
# Addresses the "ModuleNotFoundError: No module named 'requests'" issue

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "🔧 Fixing Python Dependencies for PRPLOS Framework"
echo "=================================================="

# Get the project directory
PROJECT_DIR="/home/build/prplos-tr181-testing"
if [ ! -d "$PROJECT_DIR" ]; then
    PROJECT_DIR="$HOME/prplos-tr181-testing"
fi

if [ ! -d "$PROJECT_DIR" ]; then
    error "Project directory not found. Please run the setup script first."
    exit 1
fi

cd "$PROJECT_DIR"
log "Working in: $PROJECT_DIR"

# Method 1: Install globally (quick fix)
log "Method 1: Installing requests globally..."
if pip3 install requests urllib3 beautifulsoup4 jinja2 markupsafe 2>/dev/null; then
    success "Python packages installed globally"
else
    warning "Global installation failed, trying alternatives..."
fi

# Method 2: Install with user flag
log "Method 2: Installing with --user flag..."
if pip3 install --user requests urllib3 beautifulsoup4 jinja2 markupsafe; then
    success "Python packages installed for user"
else
    warning "User installation failed, trying virtual environment..."
fi

# Method 3: Create and use virtual environment
log "Method 3: Setting up virtual environment..."
if [ ! -d "venv" ]; then
    log "Creating virtual environment..."
    python3 -m venv venv
fi

log "Activating virtual environment..."
source venv/bin/activate

log "Upgrading pip in virtual environment..."
pip install --upgrade pip

log "Installing required packages in virtual environment..."
pip install requests urllib3 beautifulsoup4 jinja2 markupsafe jsonschema pyyaml

# Create requirements.txt if it doesn't exist
if [ ! -f "requirements.txt" ]; then
    log "Creating requirements.txt..."
    cat > requirements.txt << 'EOF'
requests>=2.28.0
urllib3>=1.26.0
beautifulsoup4>=4.11.0
jinja2>=3.1.0
markupsafe>=2.1.0
jsonschema>=4.0.0
pyyaml>=6.0
EOF
fi

log "Installing from requirements.txt..."
pip install -r requirements.txt

success "Virtual environment setup complete"

# Method 4: Fix the Python runner script to handle missing modules gracefully
log "Method 4: Creating enhanced Python runner with error handling..."

cat > scripts/python_runner.py << 'EOF'
#!/usr/bin/env python3
"""
Enhanced PRPLOS TR-181 API Testing Framework - Python Runner
Includes graceful handling of missing dependencies
"""

import sys
import os
import json
import argparse
from pathlib import Path

# Check and install missing dependencies
def check_dependencies():
    """Check for required dependencies and provide installation guidance"""
    missing_modules = []
    
    try:
        import requests
    except ImportError:
        missing_modules.append('requests')
    
    try:
        import urllib3
    except ImportError:
        missing_modules.append('urllib3')
    
    if missing_modules:
        print("❌ Missing required Python modules:")
        for module in missing_modules:
            print(f"   - {module}")
        
        print("\n🔧 To fix this issue, run one of these commands:")
        print("   Option 1 (Virtual Environment - Recommended):")
        print("     cd /home/build/prplos-tr181-testing")
        print("     source venv/bin/activate")
        print("     pip install requests urllib3")
        print("")
        print("   Option 2 (Global Installation):")
        print("     pip3 install requests urllib3")
        print("")
        print("   Option 3 (User Installation):")
        print("     pip3 install --user requests urllib3")
        print("")
        print("   Option 4 (System Package Manager):")
        print("     sudo apt install python3-requests python3-urllib3")
        print("")
        return False
    
    return True

class PRPLOSTestRunner:
    def __init__(self, base_url, username, password):
        self.base_url = base_url.rstrip('/')
        self.username = username
        self.password = password
        self.session_id = None
        
        # Import requests here after dependency check
        import requests
        self.session = requests.Session()
        
    def authenticate(self):
        """Authenticate and get session token"""
        auth_url = f"{self.base_url}/session"
        payload = {
            "username": self.username,
            "password": self.password
        }
        
        try:
            response = self.session.post(auth_url, json=payload, timeout=30)
            if response.status_code == 200:
                data = response.json()
                self.session_id = data.get('session_id')
                if self.session_id:
                    print(f"✅ Authentication successful")
                    print(f"🔑 Session ID: {self.session_id[:20]}...")
                    return True
            
            print(f"❌ Authentication failed: HTTP {response.status_code}")
            if response.text:
                print(f"   Response: {response.text}")
            return False
            
        except Exception as e:
            print(f"❌ Authentication error: {e}")
            return False
    
    def test_connectivity(self):
        """Test basic connectivity to the device"""
        try:
            import requests
            test_url = f"{self.base_url}/"
            response = requests.get(test_url, timeout=10)
            print(f"✅ Device connectivity: HTTP {response.status_code}")
            return True
        except Exception as e:
            print(f"❌ Connectivity test failed: {e}")
            print(f"   Make sure {self.base_url} is accessible")
            return False
    
    def run_collection(self, collection_path):
        """Run tests from a collection file"""
        print(f"\n📋 Running collection: {Path(collection_path).name}")
        
        if not self.test_connectivity():
            return False
            
        if not self.session_id:
            if not self.authenticate():
                return False
        
        try:
            with open(collection_path, 'r') as f:
                collection = json.load(f)
            
            # Extract requests from collection
            requests_to_run = []
            for resource in collection.get('resources', []):
                if resource.get('_type') == 'request':
                    requests_to_run.append(resource)
            
            if not requests_to_run:
                print("⚠️  No test requests found in collection")
                return False
            
            print(f"🧪 Found {len(requests_to_run)} test cases")
            
            success_count = 0
            total_count = len(requests_to_run)
            
            for i, request in enumerate(requests_to_run, 1):
                print(f"\n[{i}/{total_count}] ", end="")
                if self.run_request(request):
                    success_count += 1
            
            print(f"\n📊 Results: {success_count}/{total_count} tests passed")
            success_rate = (success_count / total_count) * 100
            print(f"   Success Rate: {success_rate:.1f}%")
            
            return success_count == total_count
            
        except Exception as e:
            print(f"❌ Error running collection: {e}")
            return False
    
    def run_request(self, request_config):
        """Run individual request"""
        name = request_config.get('name', 'Unknown Test')
        method = request_config.get('method', 'GET').upper()
        url = request_config.get('url', '')
        
        # Replace template variables
        url = url.replace('{{ _.base_url }}', self.base_url)
        url = url.replace('{{ _.session_id }}', self.session_id or '')
        
        headers = {}
        if self.session_id:
            headers['Authorization'] = f'bearer {self.session_id}'
        headers['Content-Type'] = 'application/json'
        
        # Handle request body
        body_data = None
        body_config = request_config.get('body', {})
        if isinstance(body_config, dict) and 'text' in body_config:
            body_text = body_config['text']
            body_text = body_text.replace('{{ _.session_id }}', self.session_id or '')
            try:
                body_data = json.loads(body_text)
            except:
                body_data = body_text
        
        try:
            if method == 'GET':
                response = self.session.get(url, headers=headers, timeout=30)
            elif method == 'POST':
                if body_data:
                    response = self.session.post(url, json=body_data, headers=headers, timeout=30)
                else:
                    response = self.session.post(url, headers=headers, timeout=30)
            elif method == 'DELETE':
                response = self.session.delete(url, headers=headers, timeout=30)
            else:
                response = self.session.request(method, url, headers=headers, timeout=30)
            
            # Determine success
            is_success = 200 <= response.status_code < 300
            status_icon = "✅" if is_success else "❌"
            
            print(f"{status_icon} {name}: HTTP {response.status_code} ({response.elapsed.total_seconds():.2f}s)")
            
            # Show response preview for failures
            if not is_success and response.text:
                preview = response.text[:100] + "..." if len(response.text) > 100 else response.text
                print(f"     Response: {preview}")
            
            return is_success
                
        except Exception as e:
            print(f"❌ {name}: Error - {e}")
            return False

def main():
    print("🐍 PRPLOS Python API Test Runner")
    print("================================")
    
    # Check dependencies first
    if not check_dependencies():
        sys.exit(1)
    
    parser = argparse.ArgumentParser(description='PRPLOS API Test Runner')
    parser.add_argument('--ip', default='192.168.1.1', help='Device IP address')
    parser.add_argument('--username', default='admin', help='Username')
    parser.add_argument('--password', default='admin', help='Password')
    parser.add_argument('--collection', help='Specific collection to run')
    parser.add_argument('--list', action='store_true', help='List available collections')
    
    args = parser.parse_args()
    
    # Find collections directory
    script_dir = Path(__file__).parent.parent
    collections_dir = script_dir / 'collections'
    
    if not collections_dir.exists():
        print(f"❌ Collections directory not found: {collections_dir}")
        sys.exit(1)
    
    # List collections if requested
    if args.list:
        collection_files = list(collections_dir.glob("*.json"))
        if collection_files:
            print("📁 Available Collections:")
            for i, cf in enumerate(collection_files, 1):
                print(f"   {i}. {cf.stem}")
        else:
            print("❌ No collections found")
        sys.exit(0)
    
    base_url = f"http://{args.ip}"
    print(f"🎯 Target Device: {base_url}")
    print(f"👤 Username: {args.username}")
    
    runner = PRPLOSTestRunner(base_url, args.username, args.password)
    
    if args.collection:
        # Run specific collection
        collection_files = list(collections_dir.glob(f"*{args.collection}*.json"))
        if not collection_files:
            print(f"❌ Collection not found: {args.collection}")
            print("📁 Available collections:")
            for cf in collections_dir.glob("*.json"):
                print(f"   - {cf.stem}")
            sys.exit(1)
        
        success = runner.run_collection(collection_files[0])
    else:
        # Run all collections
        collection_files = list(collections_dir.glob("*.json"))
        if not collection_files:
            print("❌ No collections found")
            sys.exit(1)
        
        print(f"📚 Running {len(collection_files)} collections...")
        
        success = True
        for collection_file in sorted(collection_files):
            if not runner.run_collection(collection_file):
                success = False
    
    if success:
        print("\n🎉 All tests completed successfully!")
    else:
        print("\n⚠️  Some tests failed. Check the output above for details.")
    
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()
EOF

chmod +x scripts/python_runner.py

# Method 5: Create a simple test script to verify the fix
log "Method 5: Creating test verification script..."

cat > test_fix.py << 'EOF'
#!/usr/bin/env python3
"""Test script to verify Python dependencies are working"""

print("🧪 Testing Python Dependencies...")

try:
    import requests
    print("✅ requests module: OK")
    
    # Test a simple request
    response = requests.get("https://httpbin.org/get", timeout=5)
    print(f"✅ HTTP requests working: {response.status_code}")
    
except ImportError as e:
    print(f"❌ Import error: {e}")
    exit(1)
except Exception as e:
    print(f"⚠️  Network test failed (but module is installed): {e}")

print("✅ All Python dependencies are working!")
EOF

# Test the fix
log "Testing the fix..."
python3 test_fix.py

# Update the main run script to use virtual environment
log "Updating main run script to use virtual environment..."

# Backup original if exists
if [ -f "run_tests.sh" ]; then
    cp run_tests.sh run_tests.sh.backup
fi

# Create updated run script
cat > run_tests_fixed.sh << 'EOF'
#!/bin/bash

# Enhanced PRPLOS Testing Framework - Main Test Runner
# Fixed version with proper Python environment handling

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
cd "$SCRIPT_DIR"

# Activate virtual environment if it exists
if [ -d "venv" ] && [ -f "venv/bin/activate" ]; then
    echo "📦 Activating Python virtual environment..."
    source venv/bin/activate
fi

# Default values
DEVICE_IP="${DEVICE_IP:-192.168.1.1}"
USERNAME="${USERNAME:-admin}"
PASSWORD="${PASSWORD:-admin}"
COLLECTION=""
VERBOSE=false

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -i, --ip IP            Device IP address (default: 192.168.1.1)"
    echo "  -u, --username USER    Username (default: admin)"
    echo "  -p, --password PASS    Password (default: admin)"
    echo "  -c, --collection NAME  Collection to run (default: all)"
    echo "  -v, --verbose          Enable verbose output"
    echo "  --list                 List available collections"
    echo "  --test-deps            Test Python dependencies"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -i|--ip)
            DEVICE_IP="$2"
            shift 2
            ;;
        -u|--username)
            USERNAME="$2"
            shift 2
            ;;
        -p|--password)
            PASSWORD="$2"
            shift 2
            ;;
        -c|--collection)
            COLLECTION="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        --list)
            python3 scripts/python_runner.py --list
            exit 0
            ;;
        --test-deps)
            python3 test_fix.py
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

echo "🚀 PRPLOS TR-181 Testing Framework (Fixed Version)"
echo "================================================="
echo "Device IP: $DEVICE_IP"
echo "Username: $USERNAME"
echo "Collection: ${COLLECTION:-all}"
echo ""

# Check if Insomnia CLI is available
if command -v inso >/dev/null 2>&1; then
    echo "✅ Using Insomnia CLI: $(inso --version)"
    # Use Insomnia CLI if available
    if [ -n "$COLLECTION" ]; then
        collection_file="$SCRIPT_DIR/collections/PRPLOS-*${COLLECTION}*.json"
        if ls $collection_file 1> /dev/null 2>&1; then
            inso run test "$collection_file"
        else
            echo "❌ Collection not found: $COLLECTION"
            exit 1
        fi
    else
        for collection in "$SCRIPT_DIR/collections"/*.json; do
            echo "Running: $(basename "$collection")"
            inso run test "$collection"
        done
    fi
else
    echo "⚠️  Insomnia CLI not available, using Python runner..."
    
    # Use Python runner
    if [ -n "$COLLECTION" ]; then
        python3 scripts/python_runner.py \
            --ip "$DEVICE_IP" \
            --username "$USERNAME" \
            --password "$PASSWORD" \
            --collection "$COLLECTION"
    else
        python3 scripts/python_runner.py \
            --ip "$DEVICE_IP" \
            --username "$USERNAME" \
            --password "$PASSWORD"
    fi
fi
EOF

chmod +x run_tests_fixed.sh

success "Python dependencies have been fixed!"

echo ""
echo "🎯 SOLUTION SUMMARY:"
echo "==================="
echo ""
echo "✅ Installed required Python modules:"
echo "   - requests"
echo "   - urllib3" 
echo "   - beautifulsoup4"
echo "   - jinja2"
echo "   - markupsafe"
echo ""
echo "✅ Created virtual environment with all dependencies"
echo "✅ Enhanced Python runner with better error handling"
echo "✅ Updated main run script to use virtual environment"
echo ""
echo "🚀 TO TEST THE FIX:"
echo ""
echo "1. Test Python dependencies:"
echo "   python3 test_fix.py"
echo ""
echo "2. Run the fixed test runner:"
echo "   ./run_tests_fixed.sh --test-deps"
echo "   ./run_tests_fixed.sh -i 192.168.1.1 -u build"
echo ""
echo "3. List available collections:"
echo "   ./run_tests_fixed.sh --list"
echo ""
echo "4. Run specific collection:"
echo "   ./run_tests_fixed.sh -c authentication"
echo ""

# Clean up
rm -f test_fix.py

success "Setup complete! The 'No module named requests' error should now be resolved."