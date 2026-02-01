class archlinux::moduleblacklist {

  file { '/etc/modprobe.d':
      ensure => directory,
      recurse => true,
  }

  file { '/etc/modprobe.d/cam-blk-lst.conf':
      ensure => present,
      source => 'puppet:///modules/archlinux/cam-blk-lst.conf',
      require => File['/etc/modprobe.d'],
  }

}
