# ex: syntax=puppet si ts=4 sw=4 et

define bind::view (
    $match_clients                = 'any',
    $match_destinations           = '',
    $zones                        = [],
    $dynamic_dbs                  = [],
    $recursion                    = true,
    $recursion_match_clients      = 'any',
    $recursion_match_destinations = '',
    $recursion_match_only         = false,
    $notify_source                = '',
    $also_notify                  = [],
    $order                        = '10',
    $minimal_responses            = false,
) {
    $confdir = $::bind::confdir

    concat::fragment { "bind-view-${name}":
        order   => $order,
        target  => "${::bind::confdir}/views.conf",
        content => template('bind/view.erb'),
    }
}
