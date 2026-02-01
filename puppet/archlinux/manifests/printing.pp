class archlinux::printing {

  $printing_pkgs = ['cups',
                 'cups-pdf',
                 'foomatic-db',
                 'foomatic-db-engine',
                 'foomatic-db-gutenprint-ppds',
                 'foomatic-db-nonfree',
                 'foomatic-db-nonfree-ppds',
                 'foomatic-db-ppds',
                 'ghostscript',
                 'gutenprint']

  $printing_srvs = ['cups.service']


  package { $printing_pkgs:
    ensure => installed,
  }

  service { $printing_srvs:
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }

}
