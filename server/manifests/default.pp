# Setup DNS server
# by Jing.

node default {

  $myhostname = "admin-node"
  
  # setup name
  file { "/etc/hostname": 		content => $myhostname; 	}
  exec { "setup hostname":		command => "/bin/hostname ${myhostname}",	}
  
  # setup address mapping
  include dnsmasq
  dnsmasq::address { $myhostname:	ip  => '192.168.50.2',  }  
  dnsmasq::address { "node1":		ip  => '192.168.50.10',  }  
  dnsmasq::address { "node2":		ip  => '192.168.50.11',  }
  dnsmasq::address { "node3":		ip  => '192.168.50.12',  }
}
