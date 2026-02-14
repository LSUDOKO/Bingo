@echo off
REM ============================================
REM Django Channels Bingo Game
REM Complete Setup and Run Script for Windows
REM ============================================

echo ============================================
echo Django Channels Bingo Game - Complete Setup
echo ============================================
echo.

REM Navigate to project directory
cd /d "%~dp0"

REM ============================================
REM Step 1: Check Python Installation
REM ============================================
echo ============================================
echo Step 1: Checking Python Installation
echo ============================================
echo.

python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH!
    echo Please install Python 3.8 or higher from python.org
    pause
    exit /b 1
)

python --version
echo [OK] Python found
echo.

REM ============================================
REM Step 2: Create Virtual Environment
REM ============================================
echo ============================================
echo Step 2: Setting Up Virtual Environment
echo ============================================
echo.

if exist "venv\" (
    echo [OK] Virtual environment already exists
) else (
    echo Creating virtual environment...
    python -m venv venv
    echo [OK] Virtual environment created
)
echo.

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

REM ============================================
REM Step 3: Upgrade pip and tools
REM ============================================
echo ============================================
echo Step 3: Upgrading pip, setuptools, wheel
echo ============================================
echo.

python -m pip install --upgrade pip setuptools wheel --quiet
echo [OK] Tools upgraded
echo.

REM ============================================
REM Step 4: Install Dependencies
REM ============================================
echo ============================================
echo Step 4: Installing Dependencies
echo ============================================
echo.

echo Installing Django and core packages...
pip install Django>=4.0.2 asgiref>=3.4.1 sqlparse>=0.4.2 --quiet

echo Installing Django Channels...
pip install channels>=3.0.4 daphne>=3.0.2 --quiet

echo Installing deployment packages...
pip install whitenoise>=5.3.0 dj-database-url>=0.5.0 django-heroku>=0.3.1 gunicorn>=20.1.0 --quiet

echo Installing Twisted framework...
pip install Twisted>=22.1.0 attrs>=21.4.0 constantly>=15.1.0 incremental>=21.3.0 zope.interface>=5.4.0 --quiet

echo Installing WebSocket dependencies...
pip install autobahn>=22.1.1 Automat>=20.2.0 hyperlink>=21.0.0 idna>=3.3 txaio>=21.2.1 --quiet

echo Installing cryptography...
pip install cryptography>=41.0.0 --quiet

echo Installing remaining packages...
pip install pyOpenSSL>=23.0.0 pyasn1>=0.4.8 pyasn1-modules>=0.2.8 service-identity>=21.1.0 six>=1.16.0 typing-extensions>=4.0.1 --quiet

echo [OK] All dependencies installed successfully!
echo.

REM ============================================
REM Step 5: Database Setup
REM ============================================
echo ============================================
echo Step 5: Setting Up Database
echo ============================================
echo.

echo Running migrations...
python manage.py migrate --noinput

echo [OK] Database setup complete
echo.

REM ============================================
REM Step 6: Collect Static Files
REM ============================================
echo ============================================
echo Step 6: Collecting Static Files
echo ============================================
echo.

echo Collecting static files...
python manage.py collectstatic --noinput --clear >nul 2>&1
echo [OK] Static files collected
echo.

REM ============================================
REM Step 7: Get Network Information
REM ============================================
echo ============================================
echo Step 7: Network Configuration
echo ============================================
echo.

REM Get local IP address
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do set LOCAL_IP=%%a
set LOCAL_IP=%LOCAL_IP:~1%

REM ============================================
REM Step 8: Display Access Information
REM ============================================
echo ============================================
echo Game Ready to Start!
echo ============================================
echo.
echo Access URLs:
echo    Local:   http://localhost:8000
echo    Network: http://%LOCAL_IP%:8000
echo.
echo To play from other devices on the same network:
echo    1. Make sure all devices are on the same WiFi/Network
echo    2. Open browser on other device
echo    3. Go to: http://%LOCAL_IP%:8000
echo.
echo Game Features:
echo    - Real-time multiplayer bingo
echo    - WebSocket-based communication
echo    - Horror-themed cinematic UI
echo    - Background music and effects
echo.
echo [WARNING] To stop the server: Press Ctrl+C
echo.

REM ============================================
REM Step 9: Start the Server
REM ============================================
echo ============================================
echo Starting Django Channels Server
echo ============================================
echo.
echo Server is starting on 0.0.0.0:8000...
echo.

REM Start Daphne server
daphne -b 0.0.0.0 -p 8000 mainproject.asgi:application
