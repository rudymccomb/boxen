class projects::kinja-ops {

  repository {
    '/var/www/dash.kinja-ops.com':
      source => 'git@github.com:gawkermedia/dash.kinja-ops.com.git',
      require => File['/var/www']
  }

}
