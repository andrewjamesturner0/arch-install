class archlinux::guestuser (
  $guest_user        = $archlinux::params::guest_user,
  $guest_uid         = $archlinux::params::guest_uid,
  $guest_passwd_hash = $archlinux::params::guest_passwd_hash,
  ) inherits archlinux::params {

  user { $guest_user:
    ensure     => 'present',
    comment    => 'Guest',
    uid        => $guest_uid,
    home       => "/home/${guest_user}",
    managehome => true,
    password   => $guest_passwd_hash,
    shell      => '/bin/bash',
  }

}
