class trilio::params {
    $tvault_vm_ip                       = "192.168.1.25"
    $contego_version                    = "2.6.67"
    $contego_user	                = 'nova'
    $contego_group			= 'nova'
    $contego_conf_file			= "/etc/tvault-contego/tvault-contego.conf"
    $contego_groups			= ['kvm','qemu','disk']
    $vault_data_dir			= "/var/triliovault-mounts"
    $vault_data_dir_old			= "/var/triliovault"
    $contego_dir			= "/home/tvault"
    $contego_virtenv_dir		= "${contego_dir}/.virtenv"
    $log_dir				= "/var/log/nova"
    $contego_bin			= "${contego_virtenv_dir}/bin/tvault-contego"
    $contego_python			= "${contego_virtenv_dir}/bin/python"
    $config_files			= "--config-file=${nova_dist_conf_file} --config-file=${nova_conf_file} --config-file=${contego_conf_file}"

}
