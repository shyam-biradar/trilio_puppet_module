class trilio::contego::contego_service inherits trilio::contego {

    require trilio::contego::contego_install
    require trilio::contego::contego_postinstall

    service { 'tvault-contego':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }

}
