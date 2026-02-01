class archlinux::xorg {
  $xorg_packages = ['xorg-server',
                    'xterm',
                    'xorg-xinit',
                    'mesa',
                    'xf86-video-intel',
                    'xf86-input-libinput',]

  package { $xorg_packages:
    ensure => present,
  }
}
