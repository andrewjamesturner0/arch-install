#!/bin/bash

# install grub
arch-chroot /mnt /bin/bash -c "grub-install --target=i386-pc --recheck /dev/sda"

mkdir -p '/mnt/boot/grub/locale'

cp '/mnt/usr/share/locale/en@quot/LC_MESSAGES/grub.mo' '/mnt/boot/grub/locale/en.mo'

# change grub screen colours
sed -i '/^#GRUB_COLOR_NORMAL=/ c GRUB_COLOR_NORMAL="white/black"' /mnt/etc/default/grub
sed -i '/^#GRUB_COLOR_HIGHLIGHT=/ c GRUB_COLOR_HIGHLIGHT="cyan/blue"' /mnt/etc/default/grub

arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
