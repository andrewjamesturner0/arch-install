# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Automated Arch Linux installation framework using modular bash scripts across 4 stages: disk preparation, chroot configuration, post-reboot setup, and Puppet-based system management.

## Architecture

### Configuration

All configurable values live in `config.sh` at the repo root. This includes the storage variant, target device, hostname, locale, timezone, ZFS settings, and package lists. All scripts inherit these via `looper.sh`.

### Execution Framework

`looper.sh` is the core runner, sourced (not executed) by each stage script. It:
- Resolves `_repo_dir` from its own location
- Sources `config.sh`
- Checks for root privileges
- Provides `msg0`/`msg1` output helpers
- Provides `main()` which iterates over `install_scripts` array using absolute paths

### Stages and Script Naming Convention

Scripts in `scripts/` are prefixed by stage number. The second digit selects the storage variant:

- **Stage 1** (`1-pre-install.sh` → `scripts/1x-*.sh`): Partition disks, create filesystems, pacstrap base system. Includes device validation and destructive operation warning.
- **Stage 2** (`2-chroot-install.sh` → `scripts/2x-*.sh`): Bootloader, mkinitcpio hooks, pacman config, services. Shared scripts (`20-*.sh`) are reused across variants.
- **Stage 3** (`3-post-reboot.sh` → `scripts/3x-*.sh`): Hostname, locale, timezone (variant-independent).
- **Stage 4** (`4-run-puppet.sh` → `scripts/4x-*.sh`): Installs Puppet, applies `environments/site.pp`.

### Storage Variants

Selected by `VARIANT` in `config.sh`, dispatched via `case` statements in stage 1 and 2:

| VARIANT | Stack | Boot Mode |
|---------|-------|-----------|
| `lvm-ext4-bios` | LVM + ext4 | BIOS/GRUB |
| `luks-btrfs-uefi` | LUKS + btrfs | UEFI/GRUB |
| `luks-zfs-uefi` | LUKS + ZFS | UEFI/systemd-boot |

### Script Deduplication

Base scripts (`20-pacman.conf.sh`, `20-services.sh`) handle shared configuration. Variant-specific scripts (`22-pacman.conf-zfs.sh`, `22-services-zfs.sh`) only add their incremental changes and are listed after the base scripts in the stage 2 array.

### Key Conventions

- All scripts use `set -euo pipefail` and `#!/usr/bin/env bash`
- `_repo_dir` (set by looper.sh) is available in all scripts for absolute path references
- Config variables from `config.sh` are available in all scripts (e.g., `INSTALL_DEVICE`, `ZFS_POOL`, `ZFS_USERS`)
- `genfstab` uses `>` (overwrite) not `>>` (append) for idempotency
- `22-bootctl.sh` auto-detects the encrypted partition UUID via `blkid`

## Lint

```
shellcheck scripts/*.sh looper.sh *.sh config.sh
```
