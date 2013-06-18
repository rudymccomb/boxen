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
      provider => 'git';
  }
}
