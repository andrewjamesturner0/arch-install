# Puppet module for configuring an Arch Linux desktop system.
# Manages packages, services, users, sudo, SSH, Xorg, GNOME, and printing.
# Configuration values are read from Facter external facts set by arch-install.

class archlinux {
    include archlinux::packages
    include archlinux::pkgsfull
    include archlinux::vconsole
    include archlinux::systemdjournal
    include archlinux::rootcron
    include archlinux::services
    include archlinux::sudo
    include archlinux::user
    include archlinux::usercron
    include archlinux::ssh
    include archlinux::makepkg
    include archlinux::xorg
    include archlinux::gnome
    include archlinux::guestuser
    include archlinux::printing
    include archlinux::moduleblacklist
}
