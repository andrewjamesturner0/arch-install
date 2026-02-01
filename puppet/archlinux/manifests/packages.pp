class archlinux::packages (
  $pkgs = $archlinux::params::pkgs,
  ) inherits archlinux::params {

  package { $pkgs:
    ensure => installed,
  }
}
