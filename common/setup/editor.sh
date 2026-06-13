#!/bin/bash
set -e

if ! grep -q "^EDITOR=nvim" /etc/environment 2>/dev/null; then
    echo "EDITOR=nvim" | sudo tee -a /etc/environment > /dev/null
fi

cat /etc/environment
