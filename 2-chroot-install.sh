#!/bin/bash

#install_scripts=( \
#    20-grub-bios.sh \
#    20-mkinitcpio.conf.sh \
#    20-services.sh \
#    20-pacman.conf.sh)

#install_scripts=( \
#    21-grub-luks-btrfs-uefi.sh \
#    21-mkinitcpio.conf-luks.sh \
#    20-services.sh \
#    20-pacman.conf.sh)

install_scripts=( \
    22-bootctl.sh \
    22-pacman.conf-zfs.sh \
    22-mkinitcpio.conf-luks-zfs.sh \
    22-services-zfs.sh)


source looper.sh
main

echo ':: Set root password and reboot into new system before running stage 3.'
echo '# arch-chroot /mnt'
echo '# passwd'
echo '# reboot'
