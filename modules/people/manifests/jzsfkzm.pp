class people::jzsfkzm {
  $home = "/Users/${::luser}"

  include calibre
  include cloudapp
  include daisy_disk
  include googledrive
  include steam
  include vlc

  repository { "$home/.dotfiles":
    source => 'jzsfkzm/dotfiles'
  }
}
