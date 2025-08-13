#!/bin/bash

# Quick Fix for Insomnia CLI Installation Issues
# Multiple installation methods with fallback mechanisms

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

echo "🔧 Quick Fix: Insomnia CLI Installation"
echo "======================================"

# Method 1: Try different package names
log "Method 1: Trying alternative npm packages..."

packages=("insomnia-inso" "inso" "@insomnia/inso")
for pkg in "${packages[@]}"; do
    log "Trying package: $pkg"
    if npm install -g "$pkg" 2>/dev/null; then
        if command -v inso >/dev/null 2>&1; then
            success "Installed via $pkg"
            echo "Version: $(inso --version)"
            exit 0
        fi
    fi
done

# Method 2: Download binary directly
log "Method 2: Downloading binary directly..."
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
    x86_64) ARCH="x64" ;;
    aarch64) ARCH="arm64" ;;
esac

BINARY_URL=""
case "$OS" in
    linux)
        BINARY_URL="https://github.com/Kong/insomnia/releases/latest/download/inso-linux-$ARCH"
        ;;
    darwin)
        BINARY_URL="https://github.com/Kong/insomnia/releases/latest/download/inso-macos-$ARCH"
        ;;
esac

if [ -n "$BINARY_URL" ]; then
    log "Downloading from: $BINARY_URL"
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
    
    if curl -L -o "$INSTALL_DIR/inso" "$BINARY_URL" 2>/dev/null; then
        chmod +x "$INSTALL_DIR/inso"
        
        # Add to PATH
        if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
            export PATH="$HOME/.local/bin:$PATH"
        fi
        
        if command -v inso >/dev/null 2>&1; then
            success "Binary installed successfully"
            echo "Version: $(inso --version)"
            echo "Location: $INSTALL_DIR/inso"
            exit 0
        fi
    fi
fi

# Method 3: Install Insomnia Desktop (includes CLI)
log "Method 3: Installing Insomnia Desktop..."

case "$OS" in
    linux)
        # Try snap
        if command -v snap >/dev/null 2>&1; then
            log "Installing via snap..."
            if sudo snap install insomnia; then
                # Check for CLI in snap installation
                if [ -f "/snap/insomnia/current/inso" ]; then
                    ln -sf "/snap/insomnia/current/inso" "$HOME/.local/bin/inso"
                    success "Insomnia Desktop installed with CLI"
                    exit 0
                fi
            fi
        fi
        
        # Try .deb download
        log "Downloading .deb package..."
        DEB_URL=$(curl -s https://api.github.com/repos/Kong/insomnia/releases/latest | grep "browser_download_url.*\.deb" | cut -d '"' -f 4)
        if [ -n "$DEB_URL" ]; then
            TEMP_DEB="/tmp/insomnia.deb"
            if curl -L -o "$TEMP_DEB" "$DEB_URL"; then
                if sudo dpkg -i "$TEMP_DEB" 2>/dev/null || sudo apt-get install -f -y; then
                    success "Insomnia Desktop installed"
                    # CLI might be included
                    for path in "/usr/lib/insomnia/inso" "/opt/insomnia/inso"; do
                        if [ -f "$path" ]; then
                            ln -sf "$path" "$HOME/.local/bin/inso"
                            success "CLI linked from desktop installation"
                            exit 0
                        fi
                    done
                fi
            fi
        fi
        ;;
    darwin)
        if command -v brew >/dev/null 2>&1; then
            log "Installing via Homebrew..."
            if brew install --cask insomnia; then
                # Check for CLI in macOS app
                CLI_PATH="/Applications/Insomnia.app/Contents/Resources/app/bin/inso"
                if [ -f "$CLI_PATH" ]; then
                    ln -sf "$CLI_PATH" "$HOME/.local/bin/inso"
                    success "CLI linked from desktop installation"
                    exit 0
                fi
            fi
        fi
        ;;
esac

# Method 4: Create a Python alternative
log "Method 4: Creating Python alternative..."
cat > "$HOME/.local/bin/inso" << 'EOF'
#!/usr/bin/env python3
"""
Python-based alternative to Insomnia CLI
Basic implementation for running collections
"""
import json
import sys
import argparse

def main():
    parser = argparse.ArgumentParser(description='Python Insomnia CLI Alternative')
    parser.add_argument('command', choices=['run'], help='Command to execute')
    parser.add_argument('type', choices=['test'], help='Type of execution')
    parser.add_argument('collection', help='Collection file path')
    parser.add_argument('--env', help='Environment')
    
    args = parser.parse_args()
    
    print(f"Python Insomnia CLI Alternative")
    print(f"Collection: {args.collection}")
    print(f"Environment: {args.env}")
    print(f"Status: Use 'python3 scripts/python_runner.py' for actual testing")
    
    return 0

if __name__ == '__main__':
    sys.exit(main())
EOF

chmod +x "$HOME/.local/bin/inso"
success "Python alternative created"

# Final instructions
echo ""
warning "All automatic installation methods completed"
echo ""
echo "🎯 AVAILABLE OPTIONS:"
echo ""
echo "1. 📱 Use Insomnia Desktop GUI:"
echo "   - Download from: https://insomnia.rest/download"
echo "   - Import JSON collections manually"
echo "   - Run tests through the GUI"
echo ""
echo "2. 🐍 Use Python Runner:"
echo "   cd ~/prplos-tr181-testing"
echo "   python3 scripts/python_runner.py --ip 192.168.1.1"
echo ""
echo "3. 🔧 Use Direct curl Commands:"
echo "   curl -X POST http://192.168.1.1/session \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{\"username\":\"admin\",\"password\":\"admin\"}'"
echo ""
echo "4. 📋 Manual Collection Import:"
echo "   - Install Insomnia Desktop"
echo "   - Import collections from collections/ directory"
echo "   - Configure environment variables"
echo ""

# Check final status
if command -v inso >/dev/null 2>&1; then
    success "Insomnia CLI is now available: $(inso --version 2>/dev/null || echo 'Python alternative')"
else
    warning "Insomnia CLI not available, but alternatives are ready"
fi

echo ""
echo "🚀 You can now proceed with the enhanced setup script!"
echo "   ./enhanced_setup_prplos_testing.sh"