class archlinux::services (
  $services = $archlinux::params::services,
  ) inherits archlinux::params {

  service { $services:
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }

}
