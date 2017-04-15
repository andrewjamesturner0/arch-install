#!/usr/bin/env bash

# enable services
arch-chroot /mnt /bin/bash -c "systemctl enable dhcpcd.service"
arch-chroot /mnt /bin/bash -c "systemctl enable sshd.service"

