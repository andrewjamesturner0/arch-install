#!/bin/bash
set -euo pipefail

_pacman_conf='/mnt/etc/pacman.conf'

sed -i '/^#Color/ c Color' "${_pacman_conf}"
sed -i '/^#ParallelDownloads = 5/ c ParallelDownloads = 5' "${_pacman_conf}"

if ! grep ILoveCandy "${_pacman_conf}"; then
    sed -i '/^\[options\]/a ILoveCandy' "${_pacman_conf}"
fi
