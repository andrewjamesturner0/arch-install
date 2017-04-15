#!/bin/bash

cd scripts
chmod 755 *.sh
cd -

install_scripts=( \
    10-prep-and-install-lvm-ext4-bios.sh)
#    11-prep-and-install-luks-btrfs-uefi.sh)

source looper.sh
main
