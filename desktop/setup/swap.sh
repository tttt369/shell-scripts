#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "use sudo"
    exit 1
fi

FSTAB="/etc/fstab"
UUID="49538b9d-fe29-460b-a955-6edece14ec80"
MNT_PATH="/run/media/$UUID"
SWAP_FILE="$MNT_PATH/swapfile"
SWAP_ENTRY="$SWAP_FILE none swap sw,nofail 0 0"

cp "$FSTAB" "${FSTAB}.bak"

if ! grep -Fxq "$SWAP_ENTRY" "$FSTAB"; then
    echo "" >> "$FSTAB"
    echo "$SWAP_ENTRY" >> "$FSTAB"
fi

swapon -a

cat "$FSTAB"
swapon --show
