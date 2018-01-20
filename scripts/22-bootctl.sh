#!/bin/bash

_ESP='/mnt/boot'
_boot_conf='/loader/entries/arch.conf'

bootctl --path=/mnt/boot install

cat >> "${_ESP}${_boot_conf}" << 'EOL'
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options cryptdevice=UUID=ZZZZZ:luksroot zfs=system/ROOT/default rw
EOL

echo ":: You MUST edit ${_ESP}${_boot_conf}"


