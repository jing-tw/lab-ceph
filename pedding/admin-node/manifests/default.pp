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

  $myhostname = "admin-node"
  $domain_name_server_ip="192.168.50.2" 

  # Setup hostname
  file { "/etc/hostname": 		content => $myhostname; 	}
  exec { "setup hostname":		command => "/bin/hostname ${myhostname}",	}

 # setup customized DNS server
  file { "/etc/resolv.conf": content => "nameserver ${domain_name_server_ip}"; }


  
  # Install Ceph-deploy
  exec { 'Install ceph-deploy':              
    command => '/bin/echo Install Ceph-deploy',
    onlyif => [
      "/usr/bin/wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -" ,
      "/bin/echo deb http://ceph.com/debian-infernalis/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list",
      "/usr/bin/apt-get update && /usr/bin/apt-get install ceph-deploy ntp openssh-server sshpass -y"
    ]
  }

  # Add ceph-user for installation
  exec { 'Add user':
    command => '/bin/echo add management user OK',
    onlyif => [
      "/usr/sbin/useradd -d /home/ceph-user -m ceph-user",
      "/bin/echo ceph-user:1234 | chpasswd",
      "/bin/echo \"ceph-user ALL = (root) NOPASSWD:ALL\" | sudo tee /etc/sudoers.d/ceph-user",
      "/bin/chmod 0440 /etc/sudoers.d/ceph-user"
    ]
  }
  
  # Enable Password-less SSH
  exec { 'Enable Password-Less SSH':
    command => '/bin/echo Enable Password-Less SSH OK',
    onlyif => [
      "/bin/echo -e 'y\n'|/usr/bin/ssh-keygen -q -t rsa -N \"\" -f /root/.ssh/id_rsa",
      "/usr/bin/sudo /usr/bin/sshpass -p 1234 /usr/bin/ssh-copy-id ceph-user@node1 -o StrictHostKeyChecking=no",

      "/usr/bin/sudo /usr/bin/sshpass -p 1234 /usr/bin/ssh-copy-id ceph-user@node2 -o StrictHostKeyChecking=no",

      "/usr/bin/sudo /usr/bin/sshpass -p 1234 /usr/bin/ssh-copy-id ceph-user@node3 -o StrictHostKeyChecking=no",
      "/bin/mkdir /root/my-cluster"
    ],
  
   require => [
      Exec['Add user'],
      File['/etc/resolv.conf']
   ]
 }

  # Create Ceph Cluster
  exec { "create ceph cluster":
    command => '/bin/echo Create Ceph Cluster OK',
    cwd => '/root/my-cluster',   
    onlyif => [
      "/usr/bin/ceph-deploy new node1", 
      "/bin/echo \"osd pool default size = 2\" >> /root/my-cluster/ceph.conf"
    ],
    require => [
       Exec['Install ceph-deploy'],
       Exec['Enable Password-Less SSH']
    ]
  }

  # Let ssh login to the node with default user
    file { "/root/.ssh/config": 
      content => 
"Host node1
Hostname node1
   User ceph-user
Host node2
   Hostname node2
   User ceph-user
Host node3
   Hostname node3
   User ceph-user"; }
   
  # install other packages
  #package {'ntp':  ensure => latest,}
  #package {'openssh-server': ensure => latest,}

  # add manage user
#  user { 'ceph-user':
#    ensure => 'present', 
#    password => '1234',
#    managehome => true,}
 
 
}
