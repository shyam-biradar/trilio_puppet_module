# == Class: trilio::service
class trilio::service inherits trilio {

    file {"/home/tvault/.virtenv":
        ensure  =>  directory,
    }

    service { 'tvault-contego':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => File['/home/tvault/.virtenv']
  }

}
