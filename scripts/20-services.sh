#!/usr/bin/env bash
set -euo pipefail

# enable services
arch-chroot /mnt /bin/bash -c "systemctl enable dhcpcd.service && systemctl enable sshd.service"
