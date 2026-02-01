# arch-install

Automated Arch Linux installation scripts supporting two storage configurations:

| Variant | Filesystem | Boot Mode | Bootloader |
|---------|------------|-----------|------------|
| `lvm-ext4-bios` | ext4 on LVM | BIOS | GRUB |
| `zfs-uefi` | ZFS (with datasets) | UEFI | systemd-boot |

The installation is split into four stages, each run at a different point in the Arch install process. System settings live in `config.sh`; sensitive values (password hashes) live in `secrets.yaml`.

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

### 2. Configure

Edit `config.sh`. At minimum, review and adjust:

```bash
VARIANT="zfs-uefi"             # Choose your storage variant
INSTALL_DEVICE="/dev/sda"      # Target disk (WILL BE WIPED)
INSTALL_HOSTNAME="archlinux"
INSTALL_LOCALE="en_GB.UTF-8"
INSTALL_TIMEZONE="Europe/London"
```

For the ZFS variant, also set:

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

After rebooting into the new system, log in as root and start networking. The repo is available at `/root/arch-install` (copied during Stage 1).

```bash
systemctl start dhcpcd.service
cd /root/arch-install
./3-post-reboot.sh
```

This sets the hostname, locale, and timezone based on your `config.sh` values.

### 6. Stage 4 — Puppet (optional)

Applies desktop system configuration (packages, users, GNOME, printing, sudo, SSH hardening, etc.) via the bundled Puppet module.

**Before running**, complete two additional configuration steps:

1. Set the Puppet user variables in `config.sh`:

```bash
PUPPET_USER="ajt"
PUPPET_USER_FULLNAME="Andrew Turner"
PUPPET_USER_UID="1001"
PUPPET_GUEST_USER="guest"
PUPPET_GUEST_UID="1002"
```

2. Create `secrets.yaml` with password hashes:

```bash
cp secrets.yaml.example secrets.yaml
```

Generate hashes with `openssl passwd -6` and paste them into the file:

```yaml
user_passwd_hash: "$6$..."
guest_passwd_hash: "$6$..."
```

Then run:

```bash
./4-run-puppet.sh
```

This generates Facter external facts from `config.sh` and `secrets.yaml`, installs Puppet, and applies the manifests.

## Storage Variant Details

### `lvm-ext4-bios`

Creates a GPT partition table with a 2M BIOS boot partition and an LVM partition spanning the rest. Four logical volumes are created:

| Volume | Size | Filesystem |
|--------|------|------------|
| `bootlv` | 1G | ext4 |
| `rootlv` | 10G | ext4 |
| `homelv` | 5G | ext4 |
| `swaplv` | 1G | swap |

### `zfs-uefi`

Creates a GPT partition table with two partitions:

| Partition | Size | Purpose |
|-----------|------|---------|
| 1 | 1G | FAT32 ESP |
| 2 | remainder | ZFS pool |

The ZFS pool (`system` by default) contains:

- `ROOT/default` — root filesystem (bootfs)
- `DATA/home` — home directory root
- `DATA/home/<user>` — per-user datasets (created from `ZFS_USERS` in config)

Compression: LZ4.

## Project Structure

```
config.sh                  # All configurable values (edit this)
secrets.yaml.example       # Template for password hashes (copy to secrets.yaml)
looper.sh                  # Execution framework (sources config, runs scripts)
1-pre-install.sh           # Stage 1 entry point
2-chroot-install.sh        # Stage 2 entry point
3-post-reboot.sh           # Stage 3 entry point
4-run-puppet.sh            # Stage 4 entry point
scripts/
  1x-*.sh                  # Disk prep + base install (one per variant)
  2x-*.sh                  # Chroot config (bootloader, hooks, services, pacman)
  3x-*.sh                  # Post-reboot (hostname, locale, timezone)
  39-generate-puppet-facts.sh  # Generates Facter facts from config + secrets
  40-prepare-puppet.sh     # Installs Puppet and applies manifests
puppet/archlinux/          # Puppet module (bundled, no separate clone needed)
  manifests/               # Puppet classes
  files/                   # Static config files deployed by Puppet
  templates/               # EPP templates
environments/
  site.pp                  # Puppet entry point
```

Scripts are named `<stage><variant>-<description>.sh`. The variant digit maps to: `0` = LVM/BIOS, `2` = ZFS/UEFI. Scripts prefixed `20-` are shared across all variants.

## How It Works

Each stage script (e.g., `1-pre-install.sh`) sources `looper.sh`, which:

1. Resolves the repository path and sources `config.sh`
2. Verifies the process is running as root
3. Provides `msg0`/`msg1` output helpers and a `main()` function

The stage script then populates an `install_scripts` array (selected by `VARIANT`) and calls `main()`, which executes each script in sequence, stopping on the first failure.

Stage 4 adds a pre-step: `39-generate-puppet-facts.sh` reads `config.sh` variables and `secrets.yaml` password hashes, then writes them as Facter external facts to `/etc/facter/facts.d/arch_install.yaml`. The Puppet manifests read these facts instead of containing hardcoded values.

## License

[GNU General Public License v3](LICENSE)
