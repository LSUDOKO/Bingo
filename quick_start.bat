@echo off
REM ============================================
REM Quick Start Script for Bingo Game (Windows)
REM Use this if you've already run setup_and_run.bat once
REM ============================================

cd /d "%~dp0"

echo Starting Bingo Game...
echo.

REM Check if venv exists
if not exist "venv\" (
    echo [ERROR] Virtual environment not found!
    echo Please run setup_and_run.bat first for complete setup
    pause
    exit /b 1
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Get local IP
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do set LOCAL_IP=%%a
set LOCAL_IP=%LOCAL_IP:~1%

echo Access URLs:
echo    Local:   http://localhost:8000
echo    Network: http://%LOCAL_IP%:8000
echo.
echo [WARNING] Press Ctrl+C to stop the server
echo.

REM Start server
daphne -b 0.0.0.0 -p 8000 mainproject.asgi:application
