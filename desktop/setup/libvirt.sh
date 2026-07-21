#!/bin/bash
set -e

sudo pacman -S virt-manager
sudo pacman -S qemu-full
sudo systemctl enable libvirtd.socket
sudo virsh net-start default
