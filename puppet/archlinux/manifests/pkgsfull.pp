class archlinux::pkgsfull (
  $pkgsfull = $archlinux::params::pkgsfull,
  ) inherits archlinux::params {

    package { $pkgsfull:
      ensure => installed,
    }

}
