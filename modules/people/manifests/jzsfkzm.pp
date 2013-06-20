class people::jzsfkzm {
  $home = "/Users/${::luser}"

  include daisy_disk
  include vlc

  repository { "$home/.dotfiles":
    source => 'jzsfkzm/dotfiles'
  }
}
