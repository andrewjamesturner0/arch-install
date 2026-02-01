#!/usr/bin/env bash
set -euo pipefail

# archzfs-specific additions (base pacman.conf setup done by 20-pacman.conf.sh)
_pacman_conf='/mnt/etc/pacman.conf'

if ! grep -q archzfs "${_pacman_conf}"; then
    echo '[archzfs]' >> "${_pacman_conf}"
    echo 'Server = http://archzfs.com/$repo/x86_64' >> "${_pacman_conf}"
fi

arch-chroot /mnt /bin/bash -c "pacman-key --init && pacman-key -r ${ARCHZFS_KEY} && pacman-key --lsign-key ${ARCHZFS_KEY} && pacman -Sy --noconfirm archzfs-linux"
