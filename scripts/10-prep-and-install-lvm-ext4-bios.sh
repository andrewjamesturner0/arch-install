#!/usr/bin/env bash
# exit on errors
set -euo pipefail

# create gpt partition table on disk
parted -s "${INSTALL_DEVICE}" mklabel gpt

# create partitions
parted -s "${INSTALL_DEVICE}" -- \
    mkpart primary 1M 2M \
    mkpart primary 2M 20000M

# mark first partition as grub bios partition (because gpt)
parted -s "${INSTALL_DEVICE}" -- set 1 bios_grub on

# setup LVM
pvcreate "${INSTALL_DEVICE}2"
vgcreate vg0 "${INSTALL_DEVICE}2"
lvcreate -L 1G vg0 -n bootlv
lvcreate -L 10G vg0 -n rootlv
lvcreate -L 5G vg0 -n homelv
lvcreate -C y -L 1G vg0 -n swaplv

# create filesystems
mkfs.ext4 /dev/vg0/bootlv
mkfs.ext4 /dev/vg0/rootlv
mkfs.ext4 /dev/vg0/homelv
mkswap /dev/vg0/swaplv

# mount filesystems ready for install
mount /dev/vg0/rootlv /mnt
mkdir -p /mnt/{boot,home}
mount /dev/vg0/homelv /mnt/home
mount /dev/vg0/bootlv /mnt/boot

# install arch
pacstrap /mnt ${PACKAGES_BASE} ${PACKAGES_LVM}

genfstab -L /mnt > /mnt/etc/fstab

cp -r "${_repo_dir}" /mnt/root/
