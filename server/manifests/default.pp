# Setup admin-node 
# by Jing.

node default {

  $myhostname = "admin-node"
  
  # setup name
  file { "/etc/hostname": 		content => $myhostname; 	}
  exec { "setup hostname":		command => "/bin/hostname ${myhostname}",	}
  
  exec { 'Install Infernalis':              
    command => '/bin/echo Install Ceph-deploy',
    onlyif => [
      "/usr/bin/wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -" ,
      "/bin/echo deb http://ceph.com/debian-infernalis/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list",
      "/usr/bin/apt-get update && /usr/bin/apt-get install ceph-deploy -y"
    ]
  }
  
  # setup address mapping
  include dnsmasq
  dnsmasq::address { $myhostname:	ip  => '192.168.50.2',  }  
  dnsmasq::address { "node1":		ip  => '192.168.50.10',  }  
  dnsmasq::address { "node2":		ip  => '192.168.50.11',  }
  dnsmasq::address { "node3":		ip  => '192.168.50.12',  }
}

