class archlinux::rootcron {

  cron { pacman-orphans:
      command => "/usr/bin/pacman -Rsn --noconfirm $(pacman -Qdtq)",
      user => root,
      hour => [9,12,20],
      minute => 0,
      weekday => fri,
      require => Package['cronie'],
  }

  cron { pacman-clear-cache-1:
      command => "/usr/bin/paccache --remove --uninstalled",
      user => root,
      hour => [9,12,20],
      minute => 0,
      weekday => mon,
      require => Package['cronie'],
  }

  cron { pacman-clear-cache-2:
      command => "/usr/bin/paccache --remove --keep 2",
      user => root,
      hour => [9,12,20],
      minute => 0,
      weekday => mon,
      require => Package['cronie'],
  }

}
