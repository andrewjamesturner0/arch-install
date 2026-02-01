class archlinux::systemdjournal {

  file { '/etc/systemd/journald.conf.d':
      ensure => directory,
      recurse => true,
  }

  file { '/etc/systemd/journald.conf.d/maxuse.conf':
      ensure => present,
      source => 'puppet:///modules/archlinux/maxuse.conf',
      require => File['/etc/systemd/journald.conf.d'],
  }

}
