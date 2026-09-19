#!/bin/bash
set -e

DIR="/etc/sddm.conf.d"
FILE="${XDG_CONFIG_HOME}/autostart/sunshine.desktop"

enable() {
    systemctl --user enable app-dev.lizardbyte.app.Sunshine.service

    sed -i 's/^Hidden=true$/Hidden=false/' "$FILE"

    sudo mkdir -p /etc/sddm.conf.d
    echo "[Autologin]
User=$USER
Session=xfce.desktop" | sudo tee "${DIR}/autologin.conf"

    cat $FILE
    systemctl --user status app-dev.lizardbyte.app.Sunshine.service
}

disable() {
    systemctl --user disable app-dev.lizardbyte.app.Sunshine.service

    sed -i 's/^Hidden=false$/Hidden=true/' "$FILE"

    sudo rm "${DIR}/autologin.conf" 

    cat $FILE
    systemctl --user status app-dev.lizardbyte.app.Sunshine.service
}

if [[ "$1" == "enable" ]]; then
    enable
elif [[ "$1" == "disable" ]]; then
    disable
fi
