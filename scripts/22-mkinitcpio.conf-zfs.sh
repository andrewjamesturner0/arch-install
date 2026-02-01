#!/usr/bin/env bash
set -euo pipefail

_mkinitcpio_conf='/mnt/etc/mkinitcpio.conf'

if ! grep '^HOOKS=.*zfs' "${_mkinitcpio_conf}"; then
    sed -i '/^HOOKS=/ s/filesystems/zfs filesystems/' "${_mkinitcpio_conf}"
fi

arch-chroot /mnt /bin/bash -c "mkinitcpio -p linux"
