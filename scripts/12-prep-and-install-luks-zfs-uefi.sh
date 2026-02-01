#!/usr/bin/env bash
set -euo pipefail

# create gpt partition table on disk
parted -s "${INSTALL_DEVICE}" mklabel gpt

# create partitions
parted -s "${INSTALL_DEVICE}" -- \
    mkpart ESP fat32 1M 1G \
    mkpart primary 1G 9G \
    mkpart primary 9G 100%

parted -s "${INSTALL_DEVICE}" -- set 1 boot on

# encrypt main partition
cryptsetup \
    --cipher aes-xts-plain64 \
    --key-size 512 \
    --hash sha512 \
    --iter-time 5000 \
    --use-random \
    --verify-passphrase \
    luksFormat "${INSTALL_DEVICE}3"

# create filesystems
mkfs.fat -F32 "${INSTALL_DEVICE}1"

cryptsetup luksOpen "${INSTALL_DEVICE}3" luksroot

zpool create -f -o ashift=12 "${ZFS_POOL}" /dev/mapper/luksroot
zfs set compression=lz4 "${ZFS_POOL}"

zfs create -o mountpoint=none "${ZFS_POOL}/ROOT"
zfs create -o mountpoint=/ "${ZFS_POOL}/ROOT/default"
zfs create -o mountpoint=none "${ZFS_POOL}/DATA"
zfs create -o mountpoint=legacy "${ZFS_POOL}/DATA/home"

for user in "${ZFS_USERS[@]}"; do
    zfs create -o mountpoint=legacy "${ZFS_POOL}/DATA/home/${user}"
done

zpool set bootfs="${ZFS_POOL}/ROOT/default" "${ZFS_POOL}"

zpool export "${ZFS_POOL}"
zpool import -R /mnt "${ZFS_POOL}"

mkdir -p /mnt/{boot,home}
mount "${INSTALL_DEVICE}1" /mnt/boot
mount -t zfs "${ZFS_POOL}/DATA/home" /mnt/home

for user in "${ZFS_USERS[@]}"; do
    mkdir -p "/mnt/home/${user}"
    mount -t zfs "${ZFS_POOL}/DATA/home/${user}" "/mnt/home/${user}"
done

# install arch
pacstrap /mnt ${PACKAGES_BASE} ${PACKAGES_ZFS}

mkdir -p /mnt/etc/zfs
cp /etc/zfs/zpool.cache /mnt/etc/zfs/zpool.cache

genfstab -p /mnt > /mnt/etc/fstab
