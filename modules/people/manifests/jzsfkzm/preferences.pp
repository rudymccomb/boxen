class people::jzsfkzm::preferences {
  $my_homedir = "/Users/${::luser}"

  # Align the dock
  property_list_key { 'Align the Dock Left':
    ensure     => present,
    path       => "${my_homedir}/Library/Preferences/com.apple.dock.plist",
    key        => 'orientation',
    value      => 'left',
    notify     => Exec['Restart the Dock'],
  }

  exec { 'Restart the Dock':
    command     => '/usr/bin/killall -HUP Dock',
    refreshonly => true,
  }

  file { 'Dock Plist':
    ensure  => file,
    require => [
      Property_list_key['Align the Dock Left']
    ],
    path    => "${my_homedir}/Library/Preferences/com.apple.dock.plist",
    mode    => '0600',
    notify     => Exec['Restart the Dock'],
  }
}
