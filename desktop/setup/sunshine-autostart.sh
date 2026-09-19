#!/bin/bash
set -e

DIR="/etc/sddm.conf.d"

enable() {
    systemctl --user enable app-dev.lizardbyte.app.Sunshine.service

    sudo mkdir -p /etc/sddm.conf.d
    echo "[Autologin]
User=$USER
Session=xfce.desktop" | sudo tee "${DIR}/autologin.conf"
}

disable() {
    systemctl --user disable app-dev.lizardbyte.app.Sunshine.service
    sudo rm "${DIR}/autologin.conf" 
}

if [[ "$1" == "enable" ]]; then
    enable
elif [[ "$1" == "disable" ]]; then
    disable
fi
