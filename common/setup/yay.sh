#!/bin/bash
set -e

START_DIR=$(pwd)

sudo pacman -S --needed base-devel git

cd "$HOME"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

cd "$START_DIR"
