#!/bin/bash
set -euo pipefail

_mkinitcpio_conf='/mnt/etc/mkinitcpio.conf'

if ! grep '^HOOKS=.*lvm2' "${_mkinitcpio_conf}"; then
    sed -i '/^HOOKS=/ s/filesystem/lvm2\ filesystem/' "${_mkinitcpio_conf}"
fi

arch-chroot /mnt /bin/bash -c "mkinitcpio -p linux"
