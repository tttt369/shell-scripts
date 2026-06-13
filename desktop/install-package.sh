#!/bin/bash
set -e

aur_packages=(
    "gwe"
    "a2jmidid"
)

packages=(
    "mangohud"
    "lutris"
    "weston"
    "prismlauncher"
    "steam"
    "nvidia-open-dkms"
    "gamemode"
    "lib32-gamemode"
)

sudo pacman -S --needed "${packages[@]}"
yay -S --needed "${aur_packages[@]}"
