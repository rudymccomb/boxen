class projects::hyperion {
  repository {
    '/var/www/hyperion':
      source => 'gawkermedia/hyperion',
      require => File['/var/www']
  }

  file { '/opt/boxen/bin/tomcatdeploy':
    ensure => link,
    target => '/opt/boxen/repo/bin/tomcatdeploy'
  }

  mysql::db { 'mydb': }

  # set up tomcat6
  exec { 'downgrade_tomcat':
    command => 'cd /opt/boxen/homebrew/Library/Formula && /usr/bin/git checkout 9e18876 tomcat.rb'
  }

  package {'tomcat':
    require => Exec['downgrade_tomcat']
  }

  file { '/opt/boxen/homebrew/Cellar/tomcat/6.0.26/libexec/conf':
    ensure => 'directory',
    source => "${boxen::config::repodir}/modules/projects/files/tomcat/",
    recurse => true,
    owner => $::luser,
    group => 'wheel',
    mode => 644,
    require => Package['tomcat']
  }
}
