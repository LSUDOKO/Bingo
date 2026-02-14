#!/bin/bash

# ============================================
# Django Channels Bingo Game
# Complete Setup and Run Script
# ============================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    echo -e "${2}${1}${NC}"
}

print_header() {
    echo ""
    echo "============================================"
    print_message "$1" "$BLUE"
    echo "============================================"
}

# Navigate to project directory
cd "$(dirname "$0")"
PROJECT_DIR=$(pwd)

print_header "🎮 Django Channels Bingo Game - Complete Setup"

# ============================================
# Step 1: Check Python Installation
# ============================================
print_header "Step 1: Checking Python Installation"

if ! command -v python3 &> /dev/null; then
    print_message "❌ Python 3 is not installed!" "$RED"
    print_message "Please install Python 3.8 or higher" "$YELLOW"
    exit 1
fi

PYTHON_VERSION=$(python3 --version)
print_message "✅ Found: $PYTHON_VERSION" "$GREEN"

# ============================================
# Step 2: Create Virtual Environment
# ============================================
print_header "Step 2: Setting Up Virtual Environment"

if [ -d "venv" ]; then
    print_message "✅ Virtual environment already exists" "$GREEN"
else
    print_message "📦 Creating virtual environment..." "$YELLOW"
    python3 -m venv venv
    print_message "✅ Virtual environment created" "$GREEN"
fi

# Activate virtual environment
print_message "🔌 Activating virtual environment..." "$YELLOW"
source venv/bin/activate

# ============================================
# Step 3: Upgrade pip and tools
# ============================================
print_header "Step 3: Upgrading pip, setuptools, wheel"

pip install --upgrade pip setuptools wheel --quiet
print_message "✅ Tools upgraded" "$GREEN"

# ============================================
# Step 4: Install Dependencies
# ============================================
print_header "Step 4: Installing Dependencies"

print_message "📥 Installing Django and core packages..." "$YELLOW"
pip install Django>=4.0.2 asgiref>=3.4.1 sqlparse>=0.4.2 --quiet

print_message "📥 Installing Django Channels..." "$YELLOW"
pip install channels>=3.0.4 daphne>=3.0.2 --quiet

print_message "📥 Installing deployment packages..." "$YELLOW"
pip install whitenoise>=5.3.0 dj-database-url>=0.5.0 django-heroku>=0.3.1 gunicorn>=20.1.0 --quiet

print_message "📥 Installing Twisted framework..." "$YELLOW"
pip install Twisted>=22.1.0 attrs>=21.4.0 constantly>=15.1.0 incremental>=21.3.0 zope.interface>=5.4.0 --quiet

print_message "📥 Installing WebSocket dependencies..." "$YELLOW"
pip install autobahn>=22.1.1 Automat>=20.2.0 hyperlink>=21.0.0 idna>=3.3 txaio>=21.2.1 --quiet

print_message "📥 Installing cryptography (this may take a moment)..." "$YELLOW"
pip install cryptography>=41.0.0 --quiet 2>/dev/null || {
    print_message "⚠️  Standard cryptography installation failed, trying alternative method..." "$YELLOW"
    pip install cryptography --no-build-isolation --quiet 2>/dev/null || {
        print_message "⚠️  Cryptography installation failed. You may need system packages:" "$YELLOW"
        print_message "   Arch Linux: sudo pacman -S openssl python-cryptography" "$YELLOW"
        print_message "   Ubuntu/Debian: sudo apt-get install python3-dev libssl-dev" "$YELLOW"
        print_message "   Continuing without cryptography..." "$YELLOW"
    }
}

print_message "📥 Installing remaining packages..." "$YELLOW"
pip install pyOpenSSL>=23.0.0 pyasn1>=0.4.8 pyasn1-modules>=0.2.8 service-identity>=21.1.0 six>=1.16.0 typing-extensions>=4.0.1 --quiet

print_message "✅ All dependencies installed successfully!" "$GREEN"

# ============================================
# Step 5: Database Setup
# ============================================
print_header "Step 5: Setting Up Database"

if [ -f "db.sqlite3" ]; then
    print_message "✅ Database already exists" "$GREEN"
else
    print_message "🗄️  Creating database..." "$YELLOW"
fi

print_message "🔄 Running migrations..." "$YELLOW"
python manage.py migrate --noinput

print_message "✅ Database setup complete" "$GREEN"

# ============================================
# Step 6: Collect Static Files
# ============================================
print_header "Step 6: Collecting Static Files"

print_message "📦 Collecting static files..." "$YELLOW"
python manage.py collectstatic --noinput --clear > /dev/null 2>&1
print_message "✅ Static files collected" "$GREEN"

# ============================================
# Step 7: Get Network Information
# ============================================
print_header "Step 7: Network Configuration"

# Get local IP address
if command -v hostname &> /dev/null; then
    LOCAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
    if [ -z "$LOCAL_IP" ]; then
        LOCAL_IP=$(ip route get 1 2>/dev/null | awk '{print $7; exit}')
    fi
fi

if [ -z "$LOCAL_IP" ]; then
    LOCAL_IP="YOUR_IP_ADDRESS"
fi

# ============================================
# Step 8: Display Access Information
# ============================================
print_header "🎮 Game Ready to Start!"

echo ""
print_message "📍 Access URLs:" "$GREEN"
echo "   Local:   http://localhost:8000"
echo "   Network: http://$LOCAL_IP:8000"
echo ""
print_message "🌐 To play from other devices on the same network:" "$BLUE"
echo "   1. Make sure all devices are on the same WiFi/Network"
echo "   2. Open browser on other device"
echo "   3. Go to: http://$LOCAL_IP:8000"
echo ""
print_message "🎯 Game Features:" "$YELLOW"
echo "   • Real-time multiplayer bingo"
echo "   • WebSocket-based communication"
echo "   • Horror-themed cinematic UI"
echo "   • Background music and effects"
echo ""
print_message "⚠️  To stop the server: Press Ctrl+C" "$YELLOW"
echo ""

# ============================================
# Step 9: Start the Server
# ============================================
print_header "🚀 Starting Django Channels Server"

echo ""
print_message "Server is starting on 0.0.0.0:8000..." "$GREEN"
echo ""

# Start Daphne server
daphne -b 0.0.0.0 -p 8000 mainproject.asgi:application
