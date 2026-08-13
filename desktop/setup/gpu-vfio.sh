#!/bin/bash
set -e

GPUID=$1
GPUAUDIOID=$2

CMDLINE="/etc/kernel/cmdline"
VFIOCONF="/etc/modprobe.d/vfio.conf"
MKINIT="/etc/mkinitcpio.conf"

mkdir -p .bak
cp -n -t .bak/ "$CMDLINE" "$VFIOCONF" "$MKINIT"

echo -n " intel_iommu=on iommu=pt vfio-pci.ids=$GPUID,$GPUAUDIOID" >> $CMDLINE
echo "softdep nvidia pre: vfio-pci" > tee "$VFIOCONF"
sed -i -E 's/^MODULES=.*/MODULES=(vfio_pci vfio vfio_iommu_type1)/' "$MKINIT"

grep -H "" $CMDLINE
echo ""

grep -H "" $VFIOCONF
echo ""

grep -H "" $MKINIT | grep -E -v "(:|-)\s*#"
echo ""

read -r -p "Apply these changes and rebuild the initramfs with mkinitcpio? [y/N] " CONFIRM

if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    mkinitcpio -P
    echo "Initramfs rebuilt successfully."
else
    echo "Cancelled. Configuration files were modified, but mkinitcpio was not run."
    exit 0
fi
