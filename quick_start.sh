#!/bin/bash

# ============================================
# Quick Start Script for Bingo Game
# Use this if you've already run setup_and_run.sh once
# ============================================

cd "$(dirname "$0")"

echo "🎮 Starting Bingo Game..."
echo ""

# Check if venv exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "Please run ./setup_and_run.sh first for complete setup"
    exit 1
fi

# Activate virtual environment
source venv/bin/activate

# Get local IP
LOCAL_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
if [ -z "$LOCAL_IP" ]; then
    LOCAL_IP=$(ip route get 1 2>/dev/null | awk '{print $7; exit}')
fi
if [ -z "$LOCAL_IP" ]; then
    LOCAL_IP="YOUR_IP_ADDRESS"
fi

echo "🌐 Access URLs:"
echo "   Local:   http://localhost:8000"
echo "   Network: http://$LOCAL_IP:8000"
echo ""
echo "⚠️  Press Ctrl+C to stop the server"
echo ""

# Start server
daphne -b 0.0.0.0 -p 8000 mainproject.asgi:application
