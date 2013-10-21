class projects::kinja {

  # set up Play! 2.1.5
  exec { 'downgrade_play':
    command => 'cd /opt/boxen/homebrew/Library/Formula && /usr/bin/git checkout 39ef434 play.rb',
    require => Package['play'],
  }

  package {'play':
    require => Exec['downgrade_play'],
    ensure => '2.1.5'
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
    ruby    => '1.8.7',
    version => '>= 0'
  }

  ruby::gem { 'zurb-foundation':
    gem     => 'zurb-foundation',
    ruby    => '1.8.7',
    version => '>= 0'
  }

  ruby::gem { 'modular-scale':
    gem     => 'modular-scale',
    ruby    => '1.8.7',
    version => '>= 0'
  }

  nodejs::module { 'jslint@0.1.11':
    node_version => 'v0.10.5'
  }
}
