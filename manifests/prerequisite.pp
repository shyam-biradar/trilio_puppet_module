# == Class: trilio::prerequisite
class trilio::prerequisite inherits trilio {


    file_line { '':
        ensure => present,
        path   => '',
        line   => "<VirtualHost ${fqdn}:80>",
        match  => '<VirtualHost \*:80>',
    }    


##Make sure contego directory(/home/tvault) is available and with correct ownership
    file { 'contego_directory_ownership':
        path => $contego_dir,
        ensure => 'directory',
        owner  => $contego_user,
        group  => $contego_group,
    }














}
