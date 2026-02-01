class archlinux::makepkg {

  $makepkg_conf = '/etc/makepkg.conf'

  file_line { 'packager':
    path => $makepkg_conf,
    line => 'PACKAGER="Local User <local@user.com>"',
    match => '^PACKAGER=.*',
  }

  file_line { 'pkgext':
    path => $makepkg_conf,
    line => "PKGEXT='.pkg.tar'",
    match => '^PKGEXT=.*',
  }
}
