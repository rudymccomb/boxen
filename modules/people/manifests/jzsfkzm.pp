class people::jzsfkzm {
  $home = "/Users/${::luser}"

  include daisy_disk
  include vlc

  file { "$home/.gitconfig":
    source => "puppet:///modules/people/manifests/jzsfkzm/files/.gitconfig"
  }

  file { "$home/bin":
    ensure => 'directory',
    owner => $luser,
    group => 'staff',
    mode => 775,
    source => "$boxen::config::repodir/modules/people/manifests/jzsfkzm/files/bin",
    recurse => true
  }

}
