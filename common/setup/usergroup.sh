#!/bin/bash
set -e

CURRENT_USER=$(whoami)
GROUP_NAMES=(
    "docker"
    "gamemode"
    "adbusers"
    "wheel"
    "kvm"
)

for group in "${GROUP_NAMES[@]}"; do
    if ! getent group "${group}" > /dev/null 2>&1; then
        sudo groupadd "${group}"
    fi
    sudo usermod -aG "${group}" "${CURRENT_USER}"
done
