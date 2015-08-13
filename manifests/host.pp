import stdlib
import concat

define nagioscfg::host() {
  $host_ip_list = dnsLookup($name)
  notify { "Resolving ${name} to ${host_ip_list}": }
  $host_ips = $host_ip_list ? {
    undef   => undef,
    []      => undef,
    default => join($host_ip_list, ',')
  }
  concat::fragment {"${nagioscfg::config}_host_${name}":
    target  => "${nagioscfg::cfgdir}/${nagioscfg::config}_hosts.cfg",
    content => template('nagioscfg/host.erb'),
    order   => 30,
    notify  => Service['nagios3']
  }
}
