# ex: syntax=puppet si ts=4 sw=4 et

define bind::dynamicdb::ldap (
    $uri,
    $base_dn,
    $dbname               = 'ldap',
    $connections          = '',
    $auth_method          = '',
    $bind_dn              = '',
    $bind_password        = '',
    $sasl_mech            = '',
    $sasl_user            = '',
    $sasl_realm           = '',
    $krb5_keytab          = '',
    $krb5_principal       = '',
    $timeout              = '',
    $reconnect_interval   = '',
    $ldap_hostname        = '',
    $fake_mname           = '',
    $dynamic_updates      = true,
    $sync_ptr             = false
) {
    include bind

    exec { "rndc reconfig (dynamic db ${dbname})":
        command     => '/usr/sbin/rndc reconfig',
        user        => $::bind::params::bind_user,
        refreshonly => true,
        require     => Service['bind'],
    }

    file { "${::bind::confdir}/dynamicdbs/${dbname}.conf":
        ensure  => present,
        owner   => 'root',
        group   => $::bind::params::bind_group,
        mode    => '0644',
        content => template('bind/dynamicdb.conf.erb'),
        notify  => Exec["rndc reconfig (dynamic db ${dbname})"],
        require => Package['bind'],
    }
}
