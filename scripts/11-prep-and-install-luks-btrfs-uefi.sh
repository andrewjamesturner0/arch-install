#!/usr/bin/env bash
set -euo pipefile

# create gpt partition table on disk
parted -s /dev/sda mklabel gpt

# create partitions
parted -s /dev/sda -- \
mkpart ESP fat32 1M 1G \
# TODO mkpart swap
mkpart primary 1G 20G # better 100%
parted -s /dev/sda -- set 1 boot on

# encrypt main partition
cryptsetup \
--cipher aes-xts-plain64 \
--key-size 512 \
--hash sha512 \
--iter-time 5000 \
--use-random \
--verify-passphrase \
luksFormat /dev/sda2

# create filesystems
cryptsetup luksOpen /dev/sda2 luksroot
mkfs.btrfs /dev/mapper/luksroot
mkfs.fat -F32 /dev/sda1
mount /dev/mapper/luksroot /mnt
cd /mnt
btrfs subvolume create system
btrfs subvolume create system/root
btrfs subvolume create system/home
btrfs subvolume create snapshots
cd
umount /mnt

# mount filesystems ready for install
mount -o subvol=system/root,compress=lzo /dev/mapper/luksroot /mnt
mkdir /mnt/{home,boot}
mount -o subvol=system/home,compress=lzo /dev/mapper/luksroot /mnt/home
mount /dev/sda1 /mnt/boot

# install arch
pacstrap /mnt base base-devel grub efibootmgr btrfs-progs git vim openssh

genfstab -p /mnt >> /mnt/etc/fstab

cp -r ../../arch-install /mnt/root/
