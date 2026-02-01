class archlinux::gnome {

  $gnome_pkgs = ['gnome',
                 'gnuchess',
                 'gnome-chess',
                 'gnome-mines',
                 'gnome-nettool',
                 'gnome-software-packagekit-plugin',
                 'gnome-sound-recorder',
                 'gnome-tweaks',
                 'gnome-usage',
                 'nautilus-sendto']


  package { $gnome_pkgs:
    ensure => installed,
  }
}
