#!/usr/bin/env bash
#set -euo pipefail

# create gpt partition table on disk
parted -s /dev/sda mklabel gpt

# create partitions
parted -s /dev/sda -- \
  mkpart ESP fat32 1M 1G \
  mkpart primary 1G 9G \
  mkpart primary 9G 100%

parted -s /dev/sda -- set 1 boot on

# encrypt main partition
cryptsetup \
--cipher aes-xts-plain64 \
--key-size 512 \
--hash sha512 \
--iter-time 5000 \
--use-random \
--verify-passphrase \
luksFormat /dev/sda3

# create filesystems
mkfs.fat -F32 /dev/sda1

cryptsetup luksOpen /dev/sda3 luksroot

zpool create -f -o ashift=12 system /dev/mapper/luksroot
zfs set compression=lz4 system

zfs create -o mountpoint=none system/ROOT
zfs create -o mountpoint=/ system/ROOT/default
zfs create -o mountpoint=none system/DATA
zfs create -o mountpoint=legacy system/DATA/home
zfs create -o mountpoint=legacy system/DATA/home/guest
zfs create -o mountpoint=legacy system/DATA/home/ajt
zfs create -o mountpoint=legacy system/DATA/home/ajt/VMs
zfs create -o mountpoint=legacy system/DATA/home/ajt/tmp

zpool set bootfs=system/ROOT/default system

zpool export system
zpool import -R /mnt system

mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
mount -t zfs system/DATA/home /mnt/home
mkdir /mnt/home/{guest,ajt}
mount -t zfs system/DATA/home/guest /mnt/home/guest
mount -t zfs system/DATA/home/ajt /mnt/home/ajt
mkdir /mnt/home/ajt/{VMs,tmp}
mount -t zfs system/DATA/home/ajt/VMs /mnt/home/ajt/VMs
mount -t zfs system/DATA/home/ajt/tmp /mnt/home/ajt/tmp


# install arch
pacstrap /mnt base base-devel efibootmgr git vim openssh

mkdir -p /mnt/etc/zfs
cp /etc/zfs/zpool.cache /mnt/etc/zfs/zpool.cache

genfstab -p /mnt >> /mnt/etc/fstab
