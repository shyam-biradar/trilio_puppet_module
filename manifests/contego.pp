class trilio::contego (
  $nova_conf_file			= '/etc/nova/nova.conf',
  $nova_dist_conf_file			= '/usr/share/nova/nova-dist.conf',
  $nfs_shares				= undef,
  $nfs_options				= 'nolock,soft,timeo=180,intr',
  $tvault_appliance_ip			= undef,
  $redhat_openstack_version             = '10',
) {
  
   

      if $redhat_openstack_version == '9' {
           $openstack_release = 'mitaka'
      }
      elsif $redhat_openstack_version == '10' {
           $openstack_release = 'newton'
      }
      else {
           $openstack_release = 'premitaka'
      }

  $contego_user				= 'nova'
  $contego_group			= 'nova'
  $contego_conf_file			= "/etc/tvault-contego/tvault-contego.conf"
  $contego_groups			= ['kvm','qemu','disk']
  $vault_data_dir			= "/var/triliovault-mounts"
  $vault_data_dir_old			= "/var/triliovault"
  $contego_dir				= "/home/tvault"
  $contego_virtenv_dir			= "${contego_dir}/.virtenv"
  $log_dir				= "/var/log/nova"
  $contego_bin				= "${contego_virtenv_dir}/bin/tvault-contego"
  $contego_python			= "${contego_virtenv_dir}/bin/python"
  $config_files				= "--config-file=${nova_dist_conf_file} --config-file=${nova_conf_file} --config-file=${contego_conf_file}"
  

  $contengo_systemd_file_content	= "[Unit]
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

  $contego_conf_file_content		= "[DEFAULT]
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


    class {'trilio::contego::contego_install': }
    class {'trilio::contego::contego_postinstall': }
    class {'trilio::contego::contego_service': }

}
