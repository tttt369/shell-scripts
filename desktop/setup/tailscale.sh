#!/bin/bash
set -e

enable() {
    sudo systemctl enable --now tailscaled.service
    tailscale configure systray --enable-startup=systemd
    sudo tailscale up --ssh --operator=$USER

    systemctl --user daemon-reload
    systemctl --user enable --now tailscale-systray

    sudo systemctl status tailscaled.service --no-pager
    systemctl --user status tailscale-systray --no-pager
}

disable() {
    sudo systemctl disable --now tailscaled.service
    systemctl --user disable --now tailscale-systray

    sudo systemctl status tailscaled.service --no-pager
    systemctl --user status tailscale-systray --no-pager
}

if [[ "$1" == "enable" ]]; then
    enable
elif [[ "$1" == "disable" ]]; then
    disable
fi
