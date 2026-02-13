#!/bin/bash

# Step-by-step dependency installation for Python 3.14

cd "$(dirname "$0")"
source venv/bin/activate

echo "📦 Upgrading pip, setuptools, wheel..."
pip install --upgrade pip setuptools wheel

echo ""
echo "📥 Installing core Django packages..."
pip install Django>=4.0.2 asgiref>=3.4.1 sqlparse>=0.4.2

echo ""
echo "📥 Installing Channels..."
pip install channels>=3.0.4 daphne>=3.0.2

echo ""
echo "📥 Installing other essential packages..."
pip install whitenoise>=5.3.0 dj-database-url>=0.5.0 django-heroku>=0.3.1 gunicorn>=20.1.0

echo ""
echo "📥 Installing Twisted and dependencies..."
pip install Twisted>=22.1.0 attrs>=21.4.0 constantly>=15.1.0 incremental>=21.3.0 zope.interface>=5.4.0

echo ""
echo "📥 Installing Autobahn and WebSocket dependencies..."
pip install autobahn>=22.1.1 Automat>=20.2.0 hyperlink>=21.0.0 idna>=3.3 txaio>=21.2.1

echo ""
echo "📥 Installing cryptography (may take time)..."
pip install cryptography>=41.0.0 || {
    echo "⚠️  cryptography installation failed. Trying with system dependencies..."
    echo "   You may need to install: sudo pacman -S openssl python-cryptography"
    pip install cryptography --no-build-isolation || echo "❌ cryptography installation failed"
}

echo ""
echo "📥 Installing remaining packages..."
pip install pyOpenSSL>=23.0.0 pyasn1>=0.4.8 pyasn1-modules>=0.2.8 service-identity>=21.1.0 six>=1.16.0 typing-extensions>=4.0.1

echo ""
echo "✅ Installation complete! Checking Django..."
python -c "import django; print(f'Django {django.get_version()} installed successfully!')" || echo "❌ Django installation check failed"
