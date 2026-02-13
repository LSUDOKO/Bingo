# Django Channels Bingo Game चलाने के लिए Instructions

## ⚠️ Python 3.14 Compatibility Note
यह project Python 3.14 के साथ कुछ compatibility issues हो सकते हैं। अगर installation में problems आएं, तो नीचे दिए गए steps follow करें।

## Step 1: Virtual Environment बनाएं और Activate करें

```bash
cd /home/arpit/Desktop/django_channels_bingo_game-main
python3 -m venv venv
source venv/bin/activate
```

## Step 2: Dependencies Install करें

### विकल्प A: Automated Script (Recommended)
```bash
./install_deps.sh
```

### विकल्प B: Manual Step-by-step
```bash
pip install --upgrade pip setuptools wheel
pip install Django>=4.0.2 channels>=3.0.4 daphne>=3.0.2 asgiref>=3.4.1
pip install whitenoise>=5.3.0 dj-database-url>=0.5.0
pip install -r requirements.txt
```

### विकल्प C: अगर cryptography/cffi fail हो
Arch Linux पर system packages install करें:
```bash
sudo pacman -S openssl python-cryptography python-cffi
```
फिर:
```bash
pip install -r requirements.txt
```

## Step 3: Database Migrations चलाएं

```bash
python manage.py migrate
```

## Step 4: Server Start करें

Django Channels के लिए Daphne server use करें:

```bash
daphne -b 0.0.0.0 -p 8000 mainproject.asgi:application
```

या traditional Django runserver (कम features के साथ):

```bash
python manage.py runserver
```

## Step 5: Game Access करें

Browser में जाएं:
- http://localhost:8000

## Troubleshooting

- अगर `daphne` command नहीं मिले, तो `pip install daphne` करें
- अगर port 8000 already use हो रहा हो, तो different port use करें: `daphne -b 0.0.0.0 -p 8001 mainproject.asgi:application`
- Static files के लिए: `python manage.py collectstatic` (optional)
