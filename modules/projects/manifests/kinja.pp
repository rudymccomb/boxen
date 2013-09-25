class projects::kinja {

  # set up Play! 2.1.5
  exec { 'downgrade_play':
    command => 'cd /opt/boxen/homebrew/Library/Formula && /usr/bin/git checkout 39ef434 play.rb'
  }

  package {'play':
    require => Exec['downgrade_play']
  }

  package {
    [
      'sbt',
      'scala'
    ]:
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

  repository {
    '/var/www/kinja-core':
      source => 'gawkermedia/kinja-core',
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

  nodejs::module { 'jslint':
    node_version => 'v0.10.5'
  }
}
