# arch-install

Automated Arch Linux installation scripts supporting three storage configurations:

| Variant | Encryption | Filesystem | Boot Mode | Bootloader |
|---------|-----------|------------|-----------|------------|
| `lvm-ext4-bios` | None | ext4 on LVM | BIOS | GRUB |
| `luks-btrfs-uefi` | LUKS | btrfs (with subvolumes) | UEFI | GRUB |
| `luks-zfs-uefi` | LUKS | ZFS (with datasets) | UEFI | systemd-boot |

The installation is split into four stages, each run at a different point in the Arch install process. All configuration is centralized in a single file.

## Prerequisites

- An Arch Linux live USB/ISO environment
- An internet connection
- The target disk identified (e.g., `/dev/sda`)
- For the ZFS variant: a live environment with ZFS kernel modules available

## Quick Start

### 1. Boot the live environment and clone

```bash
git clone https://github.com/andrewjamesturner0/arch-install
cd arch-install
```

If you plan to use Stage 4 (Puppet), also clone the Puppet module:

```bash
git clone https://github.com/andrewjamesturner0/puppet-archlinux puppet/archlinux
```

### 2. Edit configuration

All settings are in `config.sh`. At minimum, review and adjust:

```bash
VARIANT="luks-zfs-uefi"       # Choose your storage variant
INSTALL_DEVICE="/dev/sda"      # Target disk (WILL BE WIPED)
INSTALL_HOSTNAME="archlinux"
INSTALL_LOCALE="en_GB.UTF-8"
INSTALL_TIMEZONE="Europe/London"
```

For the ZFS variant, also configure:

```bash
ZFS_POOL="system"
ZFS_USERS=(ajt guest)          # Home directories to create as ZFS datasets
```

You may also want to adjust partition sizes directly in the relevant `scripts/1x-*.sh` file for your chosen variant.

### 3. Stage 1 — Disk preparation and base install

Partitions the disk, creates filesystems, and installs the base system via `pacstrap`. You will be prompted to confirm before any destructive operations.

```bash
./1-pre-install.sh
```

For encrypted variants (`luks-btrfs-uefi`, `luks-zfs-uefi`), you will be prompted to set the LUKS passphrase interactively.

### 4. Stage 2 — Chroot configuration

Installs and configures the bootloader, mkinitcpio hooks, pacman settings, and system services — all within the chroot environment.

```bash
./2-chroot-install.sh
```

After Stage 2 completes, set the root password and reboot:

```bash
arch-chroot /mnt
passwd
exit
reboot
```

### 5. Stage 3 — Post-reboot setup

After rebooting into the new system, log in as root and start networking:

```bash
systemctl start dhcpcd.service
cd /root/arch-install
./3-post-reboot.sh
```

This sets the hostname, locale, and timezone based on your `config.sh` values.

### 6. Stage 4 — Puppet (optional)

Installs Puppet and applies system configuration from the `puppet-archlinux` module. Requires the module to be cloned into `puppet/archlinux` (see Step 1).

If the Puppet manifests include user accounts, add the correct password hash to `manifests/params.pp` before running.

```bash
./4-run-puppet.sh
```

## Storage Variant Details

### `lvm-ext4-bios`

Creates a GPT partition table with a 2M BIOS boot partition and an LVM partition spanning the rest. Four logical volumes are created:

| Volume | Size | Filesystem |
|--------|------|------------|
| `bootlv` | 1G | ext4 |
| `rootlv` | 10G | ext4 |
| `homelv` | 5G | ext4 |
| `swaplv` | 1G | swap |

### `luks-btrfs-uefi`

Creates a GPT partition table with a 1G FAT32 ESP and a LUKS-encrypted partition. Inside the encrypted volume, btrfs subvolumes are created:

- `system/root` — mounted at `/`
- `system/home` — mounted at `/home`
- `snapshots` — for manual snapshot management

Compression: LZO. Encryption: AES-XTS-plain64, 512-bit key, SHA-512, 5000ms iter-time.

### `luks-zfs-uefi`

Creates a GPT partition table with three partitions:

| Partition | Size | Purpose |
|-----------|------|---------|
| 1 | 1G | FAT32 ESP |
| 2 | 8G | (reserved) |
| 3 | remainder | LUKS-encrypted, ZFS pool |

The ZFS pool (`system` by default) contains:

- `ROOT/default` — root filesystem (bootfs)
- `DATA/home` — home directory root
- `DATA/home/<user>` — per-user datasets (created from `ZFS_USERS` in config)

Compression: LZ4. The encrypted partition UUID is automatically detected for the boot entry.

## Project Structure

```
config.sh                  # All configurable values (edit this)
looper.sh                  # Execution framework (sources config, runs scripts)
1-pre-install.sh           # Stage 1 entry point
2-chroot-install.sh        # Stage 2 entry point
3-post-reboot.sh           # Stage 3 entry point
4-run-puppet.sh            # Stage 4 entry point
scripts/
  1x-*.sh                  # Disk prep + base install (one per variant)
  2x-*.sh                  # Chroot config (bootloader, hooks, services, pacman)
  3x-*.sh                  # Post-reboot (hostname, locale, timezone)
  4x-*.sh                  # Puppet setup
environments/
  site.pp                  # Puppet entry point
```

Scripts are named `<stage><variant>-<description>.sh`. The variant digit maps to: `0` = LVM/BIOS, `1` = LUKS/btrfs/UEFI, `2` = LUKS/ZFS/UEFI. Scripts prefixed `20-` are shared across all variants.

## How It Works

Each stage script (e.g., `1-pre-install.sh`) sources `looper.sh`, which:

1. Resolves the repository path and sources `config.sh`
2. Verifies the process is running as root
3. Provides `msg0`/`msg1` output helpers and a `main()` function

The stage script then populates an `install_scripts` array (selected by `VARIANT`) and calls `main()`, which executes each script in sequence, stopping on the first failure.

## License

[GNU General Public License v3](LICENSE)
