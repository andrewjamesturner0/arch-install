#!/usr/bin/env bash
set -euo pipefail

_ESP='/mnt/boot'
_boot_conf='/loader/entries/arch.conf'

bootctl --path=/mnt/boot install

_uuid=$(blkid -s UUID -o value "${INSTALL_DEVICE}3")

cat > "${_ESP}${_boot_conf}" << EOL
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options cryptdevice=UUID=${_uuid}:luksroot zfs=${ZFS_POOL}/ROOT/default rw
EOL
