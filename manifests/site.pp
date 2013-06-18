require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $luser,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::luser}"
  ]
}

File {
  group => 'staff',
  owner => $luser
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => Class['git'],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::v0_4
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  # default ruby versions
  include ruby::1_8_7
  include ruby::1_9_2
  include ruby::1_9_3
  include ruby::2_0_0

  include adium
  include chrome
  include cyberduck
  include dropbox
  include firefox
  include googledrive
  include hipchat
  include iterm2::stable
  include jumpcut
  include onepassword
  include skype
  include sublime_text_2
  include textmate
  include tower
  include virtualbox

  sublime_text_2::package { 'Emmet':
    source => 'sergeche/emmet-sublime'
  }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'mc',
      'dos2unix',
      'wget',
      'curl',
      'play'
    ]:
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

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }
}
