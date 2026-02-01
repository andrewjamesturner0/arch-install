class archlinux::params {
  $user             = $facts['arch_user']
  $user_fullname    = $facts['arch_user_fullname']
  $user_uid         = $facts['arch_user_uid']
  $user_passwd_hash = $facts['arch_user_passwd_hash']
  $user_groups      = ['wheel', 'systemd-journal', 'vboxusers']

  $guest_user         = $facts['arch_guest_user']
  $guest_uid          = $facts['arch_guest_uid']
  $guest_passwd_hash  = $facts['arch_guest_passwd_hash']

  # dhcpcd and sshd are managed by arch-install stage 2 scripts
  $services       = ['cronie', 'gdm', 'NetworkManager', 'ntpd']

  $pkgs           = ['archiso',
                     'bash-completion',
                     'cronie',
                     'dosfstools',
                     'efibootmgr',
                     'git',
                     'htop',
                     'intel-ucode',
                     'jre-openjdk-headless',
                     'ntfs-3g',
                     'ntp',
                     'networkmanager',
                     'networkmanager-openvpn',
                     'openssh',
                     'p7zip',
                     'pacman-contrib',
                     'puppet',
                     'rsync',
                     'samba',
                     'sudo',
                     'tmux',
                     'vim',
                     'vim-latexsuite',
                     'vim-runtime',
                     'vim-spell-uk',
                     'zip']

  $pkgsfull       = ['aisleriot',
                     'brasero',
                     'chromium',
                     'ffmpeg',
                     'firefox',
                     'fwupd',
                     'gimp',
                     'gthumb',
                     'gpxsee',
                     'hunspell-en_GB',
                     'hyphen-en',
                     'libdvdcss',
                     'libmythes',
                     'libreoffice-fresh',
                     'libreoffice-fresh-en-gb',
                     'lm_sensors',
                     'mpv',
                     'mythes-en',
                     'noto-fonts-emoji',
                     'numix-gtk-theme',
                     'pandoc',
                     'pandoc-citeproc',
                     'qemu',
                     'r',
                     'rdesktop',
                     'rhythmbox',
                     'seahorse',
                     'seahorse-nautilus',
                     'syncthing',
                     'texlive-bibtexextra',
                     'texlive-core',
                     'texlive-fontsextra',
                     'texlive-formatsextra',
                     'texlive-games',
                     'texlive-humanities',
                     'texlive-latexextra',
                     'texlive-music',
                     'texlive-pictures',
                     'texlive-pstricks',
                     'texlive-publishers',
                     'texlive-science',
                     'ttf-bitstream-vera',
                     'vagrant',
                     'vinagre',
                     'virtualbox',
                     'virtualbox-host-dkms',
                     'virtualbox-guest-iso',
                     'youtube-dl']
}
