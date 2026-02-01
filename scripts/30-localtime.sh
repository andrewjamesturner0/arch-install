#!/usr/bin/env bash
set -euo pipefail

timedatectl set-timezone "${INSTALL_TIMEZONE}"

hwclock --systohc --utc
