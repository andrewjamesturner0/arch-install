#!/bin/bash
set -euo pipefail

_mkinitcpio_conf='/mnt/etc/mkinitcpio.conf'

if ! grep '^HOOKS=.*encrypt' "${_mkinitcpio_conf}"; then
    sed -i '/^HOOKS=/ s/filesystem/encrypt\ filesystem/' "${_mkinitcpio_conf}"
fi

arch-chroot /mnt /bin/bash -c "mkinitcpio -p linux"
