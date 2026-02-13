# Network Setup Guide - दो PCs पर Game खेलने के लिए

## Requirements
- दोनों PCs same network (WiFi/LAN) पर होने चाहिए
- Server PC पर firewall port 8000 allow होना चाहिए

## Step 1: Server PC पर Setup

### 1.1 Server PC का IP Address पता करें

**Linux/Mac:**
```bash
ip addr show
# या
ifconfig
# या
hostname -I
```

**Windows:**
```cmd
ipconfig
```

IP address मिलेगा जैसे: `192.168.1.100` या `192.168.0.50`

### 1.2 Server Start करें

```bash
cd /home/arpit/Desktop/django_channels_bingo_game-main
source venv/bin/activate
daphne -b 0.0.0.0 -p 8000 mainproject.asgi:application
```

**Note:** `-b 0.0.0.0` important है - यह सभी network interfaces पर listen करेगा

### 1.3 Firewall Allow करें (अगर जरूरी हो)

**Linux (firewalld):**
```bash
sudo firewall-cmd --add-port=8000/tcp --permanent
sudo firewall-cmd --reload
```

**Linux (ufw):**
```bash
sudo ufw allow 8000/tcp
```

**Windows:**
- Windows Firewall में port 8000 allow करें

## Step 2: Client PC पर Access करें

### 2.1 Browser में Server IP use करें

Server PC का IP address use करके browser में खोलें:
```
http://192.168.1.100:8000
```

(अपने server IP से replace करें)

### 2.2 Game खेलें

दोनों PCs पर same URL use करें और same room में join करें!

## Troubleshooting

### Connection नहीं हो रहा?

1. **Ping test करें:**
   ```bash
   ping 192.168.1.100  # Server IP
   ```

2. **Port check करें:**
   ```bash
   telnet 192.168.1.100 8000
   # या
   nc -zv 192.168.1.100 8000
   ```

3. **Server logs check करें** - connection attempts दिखेंगे

### WebSocket Connection Failed?

- Browser console में errors check करें
- Server logs में WebSocket connection errors देखें
- Firewall rules verify करें

### अगर दोनों PCs अलग networks पर हैं?

- VPN use करें, या
- Server को public IP पर deploy करें (Heroku, AWS, etc.)

## Quick Test

1. Server PC: `http://localhost:8000` खोलें
2. Client PC: `http://SERVER_IP:8000` खोलें
3. दोनों पर same room name enter करें
4. Play करें! 🎮
