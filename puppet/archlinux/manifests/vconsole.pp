class archlinux::vconsole {

  file { '/etc/vconsole.conf':
      ensure => present,
      content => 'KEYMAP=uk',
  }
}
