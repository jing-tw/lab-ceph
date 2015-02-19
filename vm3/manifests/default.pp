# Setup hostname and domain name server
# by Jing.

node default {

  $myhostname = "node3"
  $domain_name_server_ip="192.168.50.2"
  
  # setup name
  file { "/etc/hostname": 		content => $myhostname; 	}
  exec { "setup hostname":		command => "/bin/hostname ${myhostname}",	}
  
  # setup customized DNS server
  file { "/etc/resolv.conf": content => "nameserver ${domain_name_server_ip}"; }
}
