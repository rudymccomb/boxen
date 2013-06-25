class projects::hyperion {
  repository {
    '/var/www/hyperion':
      source => 'gawkermedia/hyperion',
      require => File['/var/www']
  }

  file { "/opt/boxen/bin/tomcatdeploy":
    ensure => link,
    target => "/opt/boxen/repo/bin/tomcatdeploy"
  }
}
