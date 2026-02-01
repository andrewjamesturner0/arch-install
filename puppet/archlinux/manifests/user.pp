class archlinux::user (
  $user            = $archlinux::params::user,
  $user_fullname   = $archlinux::params::user_fullname,
  $user_uid        = $archlinux::params::user_uid,
  $user_groups     = $archlinux::params::user_groups,
  $user_passwd_hash = $archlinux::params::user_passwd_hash,
  ) inherits archlinux::params {

  user { $user:
    ensure     => 'present',
    comment    => $user_fullname,
    uid        => $user_uid,
    groups     => $user_groups,
    home       => "/home/${user}",
    managehome => true,
    password   => $user_passwd_hash,
    shell      => '/bin/bash',
  }

  file { "/etc/sudoers.d/01_${user}":
    ensure  => 'present',
    content => epp('archlinux/01_user.epp', {'user' => $user}),
    mode    => '0440',
    owner   => 'root',
    group   => 'root',
  }

}
