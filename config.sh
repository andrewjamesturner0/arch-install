#!/usr/bin/env bash
# Central configuration for arch-install
# Edit these values before running the install stages.

# Storage variant: lvm-ext4-bios | luks-btrfs-uefi | luks-zfs-uefi
VARIANT="luks-zfs-uefi"

# Target disk (WARNING: will be wiped)
INSTALL_DEVICE="/dev/sda"

# System identity
INSTALL_HOSTNAME="archlinux"
INSTALL_LOCALE="en_GB.UTF-8"
INSTALL_TIMEZONE="Europe/London"

# ZFS-specific settings (only used by luks-zfs-uefi variant)
ZFS_POOL="system"
ZFS_USERS=(ajt guest)
ARCHZFS_KEY="F75D9D76"

# Packages
PACKAGES_BASE="base base-devel git vim openssh"
PACKAGES_LVM="grub"
PACKAGES_BTRFS="grub efibootmgr btrfs-progs"
PACKAGES_ZFS="efibootmgr"

# Puppet user configuration
PUPPET_USER="ajt"
PUPPET_USER_FULLNAME="Andrew Turner"
PUPPET_USER_UID="1001"
PUPPET_GUEST_USER="guest"
PUPPET_GUEST_UID="1002"
