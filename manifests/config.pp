# == Class: trilio::config
class trilio::config inherits trilio {

    $contego_systemd_file    = "[Unit]
Description=Tvault contego
After=openstack-nova-compute.service
[Service]
User=nova
Group=nova
Type=simple
ExecStart=${contego_python} ${contego_bin} ${config_files}
TimeoutStopSec=20
KillMode=process
Restart=on-failure
[Install]
WantedBy=multi-user.target
"
    $contego_conf_file	     = "[DEFAULT]
vault_storage_nfs_export = ${nfs_shares}
vault_storage_nfs_options = ${nfs_options}
vault_storage_type = nfs
vault_data_directory_old = ${vault_data_dir_old}
vault_data_directory = ${vault_data_dir}
log_file = /var/log/nova/tvault-contego.log
debug = False
verbose = True
max_uploads_pending = 3
max_commit_pending = 3
"
  
    
## Adding passwordless sudo access to 'nova' user
    file { "/etc/sudoers.d/${contego_user}":
        ensure => present,
    }


    file_line { 'Adding passwordless sudo access to nova user':
        path    => "/etc/sudoers.d/${contego_user}",
        line    => "${contego_user} ALL=(ALL) NOPASSWD: ALL",
        require => File['/etc/sudoers.d/${contego_user}']
    }   

## Adding nova user to system groups 
    user { 'Add_nova_user_to_system_groups':
        name   => $contego_user,
        ensure => present,
        gid    => $contego_group,
        groups => $contego_groups,
    } 

## Make sure contego log directory is present
    file { 'ensure_contego_log_directory':
       path   => $log_dir,
       ensure => 'directory',
       owner  => $contego_user,
       group  => $contego_group,
    }


## Ensure tvault-contego.conf file
   file { 'ensure_etc_contego_dir':
      path        => '/etc/tvault-contego',
      ensure      => 'directory',
    }

    file { "ensure_contego_conf_file":
      path        =>  "${contego_conf_file}",
      ensure      =>  present,
      content     =>  $contego_conf_file,
      require     =>  File['ensure_etc_contego_dir']
    }


## Ensure logrotate file for datamover is present on system
    file { 'ensure_log_rotate_config_file':
      path        => '/etc/logrotate.d/tvault-contego',
      source      => puppet:///modules/trilio/contego_log_rotate
    }

    file { 'ensure_contego_systemd_file':
      path        => '/etc/systemd/system/tvault-contego.service',
      content     => $contego_systemd_file,
      notify      => Exec['daemon_reload_for_contego']
    }

## Perform daemon reload if contego systemd file changes
    exec {'daemon_reload_for_contego':
      cwd         => '/tmp',
      command     => 'systemctl daemon-reload',
      path        => ['/usr/bin', '/usr/sbin',],
      refreshonly => true, 
    }    
   
}
