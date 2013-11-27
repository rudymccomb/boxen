class projects::kinja {

  # set up Play! 2.2.1, then reset play.rb to HEAD
  exec { 'downgrade_play':
    command => 'cd /opt/boxen/homebrew/Library/Formula && /usr/bin/git checkout 55d2970 play.rb',
    require  => Class['homebrew'],
  }

  package {'play':
    require => Exec['downgrade_play'],
    ensure => '2.2.1'
  }

  exec { 'reset_play_rb':
    command => 'cd /opt/boxen/homebrew/Library/Formula && /usr/bin/git reset play.rb && /usr/bin/git checkout play.rb',
    require  => Package['play']
  }

  package {
    [
      'sbt',
      'scala'
    ]:
  }

  repository {
    '/var/www/kinja-mantle':
      source => 'git@github.com:gawkermedia/kinja-mantle.git',
      require => File['/var/www']
  }

  file {
    ['/var/tmp/kinja-mantle', '/var/tmp/kinja-mantle/buildNumberDummy']:
      ensure => 'directory',
      owner => $luser,
      group => 'staff',
      mode => 775
  }

  file {
    '/var/tmp/kinja-mantle/buildNumberDummy/assets':
      ensure => link,
      target => '/var/www/kinja-mantle/target/scala-2.10/classes/public',
      require => File['/var/tmp/kinja-mantle/buildNumberDummy']
  }

  file {
    '/var/tmp/kinja-mantle/buildNumberDummy/closure':
      ensure => link,
      target => '/var/www/kinja-mantle/app/views/closure',
      require => File['/var/tmp/kinja-mantle/buildNumberDummy']
  }

  repository {
    '/var/www/kinja-common':
      source => 'git@github.com:gawkermedia/kinja-common.git',
      require => File['/var/www']
  }

  repository {
    '/var/www/kinja-core':
      source => 'git@github.com:gawkermedia/kinja-core.git',
      require => File['/var/www']
  }

  ruby::gem { 'compass':
    gem     => 'compass',
    ruby    => '1.9.3-p448',
    version => '>= 0'
  }

  ruby::gem { 'zurb-foundation':
    gem     => 'zurb-foundation',
    ruby    => '1.9.3-p448',
    version => '>= 0'
  }

  ruby::gem { 'modular-scale':
    gem     => 'modular-scale',
    ruby    => '1.9.3-p448',
    version => '>= 0'
  }

  ruby::gem { 'foundation':
    gem     => 'foundation',
    ruby    => '1.9.3-p448',
    version => '>= 0'
  }

  nodejs::module { 'bower':
    node_version => 'v0.10.21'
  }
}
