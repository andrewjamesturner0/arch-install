#!/bin/bash
# exit on errors
set -euo pipefail

# create gpt partition table on disk
parted -s /dev/sda mklabel gpt

# create partitions
parted -s /dev/sda -- \
    mkpart primary 1M 2M \
    mkpart primary 2M 20000M

# mark first partition as grub bios partition (because gpt)
parted -s /dev/sda -- set 1 bios_grub on

# setup LVM
pvcreate /dev/sda2
vgcreate vg0 /dev/sda2
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
mkdir /mnt/{boot,home}
mount /dev/vg0/homelv /mnt/home
mount /dev/vg0/bootlv /mnt/boot

# install arch
pacstrap /mnt base base-devel grub git vim openssh

genfstab -L /mnt >> /mnt/etc/fstab

cp -r ../../arch-install /mnt/root/
