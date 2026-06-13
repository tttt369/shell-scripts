#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "use sudo"
    exit 1
fi

CONF_FILE="/etc/pacman.conf"
BACKUP_FILE="${CONF_FILE}.bak"

cp "$CONF_FILE" "$BACKUP_FILE"

sed -i '/^#\[multilib\]/,/^#Include = \/etc\/pacman.d\/mirrorlist/s/^#//' "$CONF_FILE"

pacman -Sy
cat "$CONF_FILE"
