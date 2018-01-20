#!/bin/bash
set -euo pipefail

_pacman_conf='/mnt/etc/pacman.conf'

if ! grep ILoveCandy "${_pacman_conf}"; then
    sed -i '/^\[options\]/a ILoveCandy' "${_pacman_conf}"
fi

if ! grep archzfs "${_pacman_conf}"; then
    echo '[archzfs]' >> "${_pacman_conf}"
    echo 'Server = http://archzfs.com/$repo/x86_64' >> "${_pacman_conf}"
fi

arch-chroot /mnt /bin/bash -c 'pacman-key -r 5E1ABF240EE7A126'
arch-chroot /mnt /bin/bash -c 'pacman-key --lsign-key 5E1ABF240EE7A126'
arch-chroot /mnt /bin/bash -c 'pacman -Sy archzfs-linux'
