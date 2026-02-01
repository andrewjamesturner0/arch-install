# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Automated Arch Linux installation framework using modular bash scripts across 4 stages: disk preparation, chroot configuration, post-reboot setup, and Puppet-based system management.

## Architecture

### Configuration

All configurable values live in `config.sh` at the repo root. This includes the storage variant, target device, hostname, locale, timezone, ZFS settings, package lists, and Puppet user settings. All scripts inherit these via `looper.sh`.

Sensitive values (password hashes) go in `secrets.yaml` (gitignored). Copy `secrets.yaml.example` to get started.

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
- **Stage 4** (`4-run-puppet.sh` → `scripts/39-*.sh`, `scripts/4x-*.sh`): Generates Facter facts from `config.sh` + `secrets.yaml`, installs Puppet, applies `environments/site.pp`.

### Storage Variants

Selected by `VARIANT` in `config.sh`, dispatched via `case` statements in stage 1 and 2:

| VARIANT | Stack | Boot Mode |
|---------|-------|-----------|
| `lvm-ext4-bios` | LVM + ext4 | BIOS/GRUB |
| `zfs-uefi` | ZFS | UEFI/systemd-boot |

### Script Deduplication

Base scripts (`20-pacman.conf.sh`, `20-services.sh`) handle shared configuration. Variant-specific scripts (`22-pacman.conf-zfs.sh`, `22-services-zfs.sh`) only add their incremental changes and are listed after the base scripts in the stage 2 array.

### Puppet Module (`puppet/archlinux/`)

Bundled Puppet module for desktop system configuration. Key design:

- **`params.pp`**: Reads all user/system config from Facter external facts (`$facts['arch_user']`, etc.) set by `scripts/39-generate-puppet-facts.sh`. No hardcoded values.
- **`secrets.yaml`** (repo root, gitignored): Holds password hashes. Parsed by the facts script and written to `/etc/facter/facts.d/arch_install.yaml`.
- Classes use `inherits archlinux::params` to access shared parameters.
- `init.pp` includes all sub-classes: packages, services, user, guestuser, sudo, ssh, usercron, xorg, gnome, printing, etc.

### Key Conventions

- All scripts use `set -euo pipefail` and `#!/usr/bin/env bash`
- `_repo_dir` (set by looper.sh) is available in all scripts for absolute path references
- Config variables from `config.sh` are available in all scripts (e.g., `INSTALL_DEVICE`, `ZFS_POOL`, `ZFS_USERS`, `PUPPET_USER`)
- `genfstab` uses `>` (overwrite) not `>>` (append) for idempotency
- `22-bootctl.sh` configures systemd-boot with the ZFS boot entry

## Lint

```
shellcheck scripts/*.sh looper.sh *.sh config.sh
```
