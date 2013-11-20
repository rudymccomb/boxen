class projects::hyperion {
  repository {
    '/var/www/hyperion':
      source => 'git@github.com:gawkermedia/hyperion.git',
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

  # set up tomcat6, then reset tomcat.rb to HEAD
  exec { 'downgrade_tomcat':
    command => 'cd /opt/boxen/homebrew/Library/Formula && /usr/bin/git checkout 9e18876 tomcat.rb',
    require  => Class['homebrew'],
  }

  package {'tomcat':
    require => Exec['downgrade_tomcat'],
    ensure => '6.0.26'
  }

  exec { 'reset_tomcat_rb':
    command => 'cd /opt/boxen/homebrew/Library/Formula && /usr/bin/git reset tomcat.rb && /usr/bin/git co tomcat.rb',
    require  => Package['tomcat']
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
