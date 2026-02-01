#!/usr/bin/env bash
set -euo pipefail

# ZFS-specific service (base services enabled by 20-services.sh)
arch-chroot /mnt /bin/bash -c "systemctl enable zfs.target"
