class archlinux::usercron (
  $user = $archlinux::params::user,
  ) inherits archlinux::params {

  cron { clear-downloads:
      command => "/usr/bin/find /home/${user}/Downloads/ -mtime +30 -delete",
      user    => $user,
      hour    => 20,
      minute  => 0,
      require => Package['cronie'],
  }
}
