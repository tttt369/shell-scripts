#!/bin/bash
set -e

pkg update
termux-setup-storage
pkg install -y proot-distro vim termux-api sudo
proot-distro install archlinux
proot-distro login archlinux --bind ~/storage:/mnt
