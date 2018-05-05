class trilio::contego::contego_postinstall inherits trilio::contego {
  
    require trilio::contego::contego_install   
## Adding passwordless sudo access to 'nova' user
    file { "/etc/sudoers.d/${contego_user}":
        ensure => present,
    }->
    file_line { 'Adding passwordless sudo access to nova user':
        path   => "/etc/sudoers.d/${contego_user}",
        line   => "${contego_user} ALL=(ALL) NOPASSWD: ALL",
    }


##Ensure contego log directory /var/log/nova
    file { "/var/log/nova/":
        ensure => 'directory',
        owner  => $contego_user,
        group  => $contego_group,
    }


##Create /etc/tvault-contego/ directory and tvault-contego.conf
    file { '/etc/tvault-contego/':
        ensure => 'directory',
    }->
    file { "/etc/tvault-contego/tvault-contego.conf":
        ensure  => present,
        content => $contego_conf_file_content,
    }

##Create log rorate file for contego log rotation: /etc/logrotate.d/tvault-contego
    file { '/etc/logrotate.d/tvault-contego':
        source  => 'puppet:///modules/trilio/log_rotate_conf',
    }

##Create systemd file for tvault-contego service: /etc/systemd/system/tvault-contego.service
    file { '/etc/systemd/system/tvault-contego.service':
        content => $contengo_systemd_file_content,
    }

##Perform daemon reload if any changes happens in contego systemd file
    exec { 'daemon_reload_for_contego':
        cwd         => '/tmp',
        command     => 'systemctl daemon-reload',
        path        => ['/usr/bin', '/usr/sbin',],
        subscribe   => File['/etc/systemd/system/tvault-contego.service'],
        refreshonly => true,
    }

}
