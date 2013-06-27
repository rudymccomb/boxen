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

  mysql::db { 'hyperion':
    ensure => 'present'
  }

  mysql::db { 'hyperion_test':
    ensure => 'present'
  }

  # set up tomcat6
  exec { 'downgrade_tomcat':
    command => 'cd /opt/boxen/homebrew/Library/Formula && /usr/bin/git checkout 9e18876 tomcat.rb'
  }

  package {'tomcat':
    require => Exec['downgrade_tomcat']
  }

  file { '/opt/boxen/homebrew/Cellar/tomcat/6.0.26/libexec/conf':
    ensure => 'directory',
    source => "${boxen::config::repodir}/modules/projects/files/tomcat/conf/",
    recurse => true,
    owner => $::luser,
    group => 'wheel',
    mode => 644,
    require => Package['tomcat']
  }

  file { '/opt/boxen/homebrew/Cellar/tomcat/6.0.26/libexec/lib/mysql-connector-java-5.1.25.jar':
    ensure => 'file',
    source => "${boxen::config::repodir}/modules/projects/files/tomcat/lib/mysql-connector-java-5.1.25.jar",
    owner => $::luser,
    group => 'wheel',
    mode => 644,
    require => Package['tomcat']
  }
}
