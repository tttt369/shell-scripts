set -e

INDEX=1
SOURCE_ISO="./19044.1288.211006-0501.21h2_release_svc_refresh_CLIENT_LTSC_EVAL_x64FRE_en-us.iso"
OUTPUT_ISO="./patched.iso"
WIM_FILE="./install.wim"
WORK_DIR="./temp"

echo "Extracting install.wim from ISO using 7zip"
7z e -y "$SOURCE_ISO" "sources/$WIM_FILE"

echo "Extracting registry hives from WIM"
wimextract "$WIM_FILE" "$INDEX" /Windows/System32/config/SOFTWARE --dest-dir=.
wimextract "$WIM_FILE" "$INDEX" /Windows/System32/config/SYSTEM --dest-dir=.

echo "Applying patches to hives"
hivexregedit --merge --prefix='HKEY_LOCAL_MACHINE\SOFTWARE' SOFTWARE software.reg
hivexregedit --merge --prefix='HKEY_LOCAL_MACHINE\SYSTEM' SYSTEM system.reg

echo "Updating WIM image"
wimupdate "$WIM_FILE" "$INDEX" <<EOF
add SOFTWARE /Windows/System32/config/SOFTWARE
add SYSTEM /Windows/System32/config/SYSTEM
EOF

echo "Optimizing WIM file"
wimoptimize "$WIM_FILE"

echo "Rebuilding ISO structure"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"

echo "Extracting full ISO structure"
7z x -y "-xr!$WIM_FILE" "$SOURCE_ISO" -o"$WORK_DIR"

echo "Placing patched install.wim into workspace"
mv "$WIM_FILE" "$WORK_DIR/sources/$WIM_FILE"

xorriso -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid "BOOTABLE_WIN" \
  -eltorito-boot "boot/etfsboot.com" \
  -no-emul-boot \
  -boot-load-size 8 \
  -eltorito-alt-boot \
  -e "efi/microsoft/boot/efisys.bin" \
  -no-emul-boot \
  -o "$OUTPUT_ISO" \
  "$WORK_DIR"

echo "Cleaning up temporary files"
rm -f SOFTWARE SYSTEM software_patch.reg system_patch.reg
rm -rf "$WORK_DIR"

echo "Process Completed Successfully! Created: $OUTPUT_ISO"
