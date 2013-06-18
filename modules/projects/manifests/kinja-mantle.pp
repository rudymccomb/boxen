class projects::kinja-mantle {
  file { '/var/www':
    ensure => 'directory',
    owner => $luser,
    group => 'staff',
    mode => 775
  }

  repository {
    '/var/www/kinja-mantle':
      source => 'gawkermedia/kinja-mantle',
      require => File['/var/www']
  }

  repository {
    '/var/www/kinja-common':
      source => 'gawkermedia/kinja-common',
      require => File['/var/www']
  }
}
