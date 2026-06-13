#!/bin/bash
set -e

sudo systemctl enable NetworkManager.service
sudo systemctl status NetworkManager.service
