#!/bin/sh
set -e

echo "[INFO] Adminer setup starting..."

if [ ! -f /var/www/adminer/index.php ]; then
    echo "[INFO] Downloading Adminer..."
    wget -q -O /var/www/adminer/index.php \
        "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php"
    wget -q -O /var/www/adminer/editor.php \
        "https://github.com/vrana/adminer/releases/download/v4.8.1/editor-4.8.1.php"
    
    if [ -f /var/www/adminer/index.php ]; then
        echo "[SUCCESS] Adminer downloaded"
    else
        echo "[ERROR] Failed to download Adminer"
        exit 1
    fi
else
    echo "[INFO] Adminer already exists, skipping download"
fi

echo "[INFO] Starting Adminer server..."
exec php -S 0.0.0.0:8081 -t /var/www/adminer
