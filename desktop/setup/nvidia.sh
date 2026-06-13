#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "use sudo"
    exit 1
fi

cat << 'EOF' > /etc/systemd/system/nvidia-tdp.service
[Unit]
Description=Set NVIDIA power limit

[Service]
Type=oneshot
ExecStartPre=/usr/bin/nvidia-smi -pm 1
ExecStart=/usr/bin/nvidia-smi -pl 100
EOF

cat << 'EOF' > /etc/systemd/system/nvidia-tdp.timer
[Unit]
Description=Timer for setting NVIDIA power limit

[Timer]
OnBootSec=5
Unit=nvidia-tdp.service

[Install]
WantedBy=timers.target
EOF

chmod 0644 /etc/systemd/system/nvidia-tdp.service
chmod 0644 /etc/systemd/system/nvidia-tdp.timer

chown root:root /etc/systemd/system/nvidia-tdp.service
chown root:root /etc/systemd/system/nvidia-tdp.timer

systemctl daemon-reload
systemctl enable nvidia-tdp.timer
systemctl start nvidia-tdp.timer

systemctl status nvidia-tdp.timer
