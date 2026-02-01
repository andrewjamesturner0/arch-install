#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/looper.sh"

# validate target device exists
if [[ ! -b "${INSTALL_DEVICE}" ]]; then
    echo "ERROR: Device ${INSTALL_DEVICE} not found" >&2
    exit 1
fi

echo "WARNING: This will DESTROY all data on ${INSTALL_DEVICE}"
read -rp "Continue? [y/N] " confirm
[[ "${confirm}" == "y" ]] || exit 1

case "${VARIANT}" in
    lvm-ext4-bios)
        install_scripts=(10-prep-and-install-lvm-ext4-bios.sh) ;;
    luks-btrfs-uefi)
        install_scripts=(11-prep-and-install-luks-btrfs-uefi.sh) ;;
    luks-zfs-uefi)
        install_scripts=(12-prep-and-install-luks-zfs-uefi.sh) ;;
    *)
        echo "ERROR: Unknown VARIANT '${VARIANT}'" >&2; exit 1 ;;
esac

main
