class archlinux::sudo {

  file { '/etc/sudoers.d':
    ensure => directory,
    mode   => '0750',
    owner  => 'root',
    group  => 'root',
    require => Package['sudo'],
  }

  file { '/etc/sudoers.d/00_insults':
    ensure => present,
    source => 'puppet:///modules/archlinux/00_insults',
    mode   => '0440',
    owner  => 'root',
    group  => 'root',
    require => File['/etc/sudoers.d'],
  }

  file { '/etc/sudoers.d/00_power_alias':
    ensure => present,
    source => 'puppet:///modules/archlinux/00_power_alias',
    mode   => '0440',
    owner  => 'root',
    group  => 'root',
    require => File['/etc/sudoers.d'],
  }

  file { '/etc/sudoers.d/00_wheel_all':
    ensure => present,
    source => 'puppet:///modules/archlinux/00_wheel_all',
    mode   => '0440',
    owner  => 'root',
    group  => 'root',
    require => File['/etc/sudoers.d'],
  }

}
