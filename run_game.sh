#!/bin/bash

# Django Channels Bingo Game Run Script

echo "🚀 Django Channels Bingo Game Setup और Run कर रहे हैं..."

# Project directory में जाएं
cd "$(dirname "$0")"

# Virtual environment check करें
if [ ! -d "venv" ]; then
    echo "📦 Virtual environment बना रहे हैं..."
    python3 -m venv venv
fi

# Virtual environment activate करें
echo "🔌 Virtual environment activate कर रहे हैं..."
source venv/bin/activate

# Dependencies install करें
echo "📥 Dependencies install कर रहे हैं..."
if [ -f "install_deps.sh" ]; then
    ./install_deps.sh
else
    pip install --upgrade pip setuptools wheel
    pip install -r requirements.txt || echo "⚠️  Some packages failed to install, but continuing..."
fi

# Migrations चलाएं
echo "🗄️  Database migrations चल रहे हैं..."
python manage.py migrate

# Server start करें
echo "🎮 Server start हो रहा है..."
echo ""
echo "🌐 Local access: http://localhost:8000"
echo ""
echo "📡 Network access के लिए:"
echo "   1. Server IP पता करें: hostname -I (Linux) या ipconfig (Windows)"
echo "   2. दूसरे PC पर browser में खोलें: http://YOUR_IP:8000"
echo "   3. दोनों PCs same network पर होने चाहिए"
echo ""
echo "Server को stop करने के लिए Ctrl+C दबाएं"
echo ""

daphne -b 0.0.0.0 -p 8000 mainproject.asgi:application
