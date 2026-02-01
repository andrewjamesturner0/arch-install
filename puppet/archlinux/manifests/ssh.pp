class archlinux::ssh {

 $sshd_conf = '/etc/ssh/sshd_config'

 file { $sshd_conf:
   ensure  => 'present',
   require => Package['openssh'],
  }

 file_line {'rootlogin':
   path    => $sshd_conf,
   line    => 'PermitRootLogin without-password',
   match   => '^#PermitRootLogin.*',
   require => File[$sshd_conf],
  }

 file_line {'passwdauth':
   path    => $sshd_conf,
   line    => 'PasswordAuthentication no',
   match   => '^#PasswordAuthentication.*',
   require => File[$sshd_conf],
  }
}
