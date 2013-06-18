class people::jzsfkzm {
  $home = "/Users/${::luser}"

  include daisy_disk
  include vlc

  file { "$home/bin":
    ensure => 'directory',
    owner => $luser,
    group => 'staff',
    mode => 775
  }

  file { "$home/.gitconfig":
    source => "puppet:///modules/people/manifests/jzsfkzm/files/.gitconfig"
  }

  file { "$home/bin":
    source => "puppet:///modules/people/manifests/jzsfkzm/files/bin",
    recurse => true
  }

}
