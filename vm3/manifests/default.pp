# Setup auto setup network interface
# by Jing.
# Reference
# 	https://forge.puppetlabs.com/adrien/network

node default {
  # setup name
  file { "/etc/hostname": 		content => "vm3"; 	}
  exec { "setup hostname":		command => "/bin/hostname vm3",	}
  
  # setup customized DNS server
  file { "/etc/resolv.conf": content => "nameserver 192.168.50.2"; }
  
}
