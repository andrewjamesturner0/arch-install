#!/usr/bin/env bash
set -euo pipefail

# create gpt partition table on disk
parted -s "${INSTALL_DEVICE}" mklabel gpt

# create partitions
parted -s "${INSTALL_DEVICE}" -- \
    mkpart ESP fat32 1M 1G \
    mkpart primary 1G 20G
parted -s "${INSTALL_DEVICE}" -- set 1 boot on

# encrypt main partition
cryptsetup \
    --cipher aes-xts-plain64 \
    --key-size 512 \
    --hash sha512 \
    --iter-time 5000 \
    --use-random \
    --verify-passphrase \
    luksFormat "${INSTALL_DEVICE}2"

# create filesystems
cryptsetup luksOpen "${INSTALL_DEVICE}2" luksroot
mkfs.btrfs /dev/mapper/luksroot
mkfs.fat -F32 "${INSTALL_DEVICE}1"
mount /dev/mapper/luksroot /mnt
btrfs subvolume create /mnt/system
btrfs subvolume create /mnt/system/root
btrfs subvolume create /mnt/system/home
btrfs subvolume create /mnt/snapshots
umount /mnt

# mount filesystems ready for install
mount -o subvol=system/root,compress=lzo /dev/mapper/luksroot /mnt
mkdir -p /mnt/{home,boot}
mount -o subvol=system/home,compress=lzo /dev/mapper/luksroot /mnt/home
mount "${INSTALL_DEVICE}1" /mnt/boot

# install arch
pacstrap /mnt ${PACKAGES_BASE} ${PACKAGES_BTRFS}

genfstab -p /mnt > /mnt/etc/fstab

cp -r "${_repo_dir}" /mnt/root/
