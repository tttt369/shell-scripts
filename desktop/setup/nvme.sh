#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "use sudo"
    exit 1
fi

FSTAB="/etc/fstab"
UUID="49538b9d-fe29-460b-a955-6edece14ec80"
MNT_PATH="/run/media/$UUID"
ENTRY="UUID=$UUID $MNT_PATH ext4 defaults,noatime 0 2"

mkdir -p "$MNT_PATH"
cp "$FSTAB" "${FSTAB}.bak"

if ! grep -Fxq "$ENTRY" "$FSTAB"; then
    echo "" >> "$FSTAB"
    echo "# $MNT_PATH" >> "$FSTAB"
    echo "$ENTRY" >> "$FSTAB"
fi

mount -a
cat $FSTAB
