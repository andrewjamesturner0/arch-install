# Scripts to install Archlinux

Start with an archlinux live environment.

Start with an Antergos live environment if zfs modules are needed.

    # git clone https://github.com/andrewjamesturner0/arch-install
    # cd arch-install
    # git clone https://github.com/andrewjamesturner0/puppet-archlinux puppet/archlinux

Set correct partition sizes in `scripts/1[...]`.

    # ./1-pre-install.sh
    # ./2-chroot-install.sh
    # arch-chroot /mnt
    # passwd
    # exit

Shutdown live environment. Reboot machine.

Log in.

    # systemctl start dhcpcd.service
    # ./3-post-reboot.sh

Add correct password hash to `manifests/params.pp`.

    # ./4-prepare-puppet.sh
