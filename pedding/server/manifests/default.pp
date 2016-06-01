# Setup admin-node
# Usage:
#   [node1] vagrant up && vagrant ssh
#   [node2] vagrant up && vagrant ssh
#   [node3] vagrant up && vagrant ssh
#   [admin-node] vagrant up 
# TODO fix
#   [admin-node] vagrant provision
#   vagrant ssh
#   sudo su
#   ssh node1  # for test ssh without password
# by Jing.

node default {

  $myhostname = "dns-node"
  
  # Setup hostname
  file { "/etc/hostname": 		content => $myhostname; 	}
  exec { "setup hostname":		command => "/bin/hostname ${myhostname}",	}

   # setup address mapping
  include dnsmasq
  dnsmasq::address { $myhostname:	ip  => '192.168.50.2', }  
  dnsmasq::address { "admin-node":      ip  => '192.168.50.3', }
  dnsmasq::address { "node1":		ip  => '192.168.50.10', }  
  dnsmasq::address { "node2":		ip  => '192.168.50.11', }
  dnsmasq::address { "node3":		ip  => '192.168.50.12', }
}
