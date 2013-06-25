class projects::all {
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

  include_all_projects()
}
