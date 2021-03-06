require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

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
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
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
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node 'default' {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include mysql
  include nginx
  include redis

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10
  class { 'nodejs::global':
    version => 'v0.10.21'
  }

  # default ruby versions
  include ruby::1_8_7
  include ruby::1_9_2
  include ruby::1_9_3
  include ruby::2_0_0
  class { 'ruby::global':
    version => '1.9.3-p448'
  }

  # common, useful packages, default from brew
  package {
    [
      'ack',
      'curl',
      'dos2unix',
      'findutils',
      'gnu-tar',
      'htop',
      'mc',
      'wget',
      'pkg-config',
      'unrar'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }

  file { "${boxen::config::bindir}/subl":
    ensure  => link,
    target  => '/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl',
    mode    => '0755'
  }

  file { '/var/www':
    ensure => 'directory',
    owner => $luser,
    group => 'staff',
    mode => 775
  }

  file { "/www":
    ensure => link,
    target => "/var/www"
  }

  include projects::kinja
  include projects::kinja-ops
  include projects::hyperion

  # desktop applications
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
  include textmate
  include tower
  include transmission
  include virtualbox
  include viscosity

#  sublime_text_2::package { 'Emmet':
#    source => 'sergeche/emmet-sublime'
#  }

#  sublime_text_2::package { 'Package Control':
#    source => 'wbond/sublime_package_control'
#  }

#  sublime_text_2::package { 'JSLint':
#    source => 'darrenderidder/Sublime-JSLint'
#  }

#  sublime_text_2::package { 'DocBlockr':
#    source => 'spadgos/sublime-jsdocs'
#  }

#  sublime_text_2::package { 'SoyTemplate':
#    source => 'anvie/SoyTemplate'
#  }

#  file { "/Users/$luser/Library/Application Support/Sublime Text 2/Packages/User/JSLint.sublime-build":
#    source => "$boxen::config::repodir/modules/projects/files/JSLint.sublime-build"
#  }
}
