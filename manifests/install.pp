# == Class: trilio::install
class trilio::install inherits trilio {

   

    python::pip { 'tvault-contego' :
        pkgname       => 'tvault-contego',
        ensure        => '2.6.67',
        virtualenv    => '/home/tvault/.virtenv/',
        url           => "http://192.168.1.25:8081/packages/tvault-contego-2.6.67.tar.gz",
        owner         => 'nova',
        group         => 'nova',
        timeout       => 1800,
 } 
}
