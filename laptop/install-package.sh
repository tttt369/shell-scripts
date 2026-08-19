#!/bin/bash
set -e

aur_packages=(
    "auto-cpufreq"
)

packages=(
    "thermald"
    "blueman"
)

sudo pacman -S --needed "${packages[@]}"
yay -S --needed "${aur_packages[@]}"
