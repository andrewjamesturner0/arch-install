#!/bin/bash
set -euo pipefail

_pacman_conf='/mnt/etc/pacman.conf'

if ! grep ILoveCandy "${_pacman_conf}"; then
    sed -i '/^\[options\]/a ILoveCandy' "${_pacman_conf}"
fi
