# lab-ceph

A test lab for deployment the ceph system at home

github: https://github.com/jing-tw/lab-ceph/blob/master/README.md
 
by Jing.

### Requirement
1. VirtualBox
2. Vagrant
	vagrant box add ubuntu/trusty64
3. Puppet
	sudo apt-get install puppetmaster
	- puppet module install adrien-network

### Usage:
1. Start DNS Server
	- ~/lab-ceph/server$ vagrant up
2. Get Ready the Node for Ceph Deploy
	- ~/lab-ceph/node1$ vagrant up && vagrant ssh
	- ~/lab-ceph/node2$ vagrant up && vagrant ssh
 	- ~/lab-ceph/node3$ vagrant up && vagrant ssh
3. Start the Ceph Deploy Node
	- ~/lab-ceph/admin-node$ vagrant up && vagrant ssh

### Followup:
1. [admin-node]
    - sudo su; 
    - cd /root/my-cluster
    - /usr/bin/ceph-deploy new node1 (has run by admin-node puppet code)
    - ceph-deploy install admin-node node1 node2 node3
    - ceph-deploy mon create-initial
    - ceph-deploy osd prepare node2:/var/local/osd0 node3:/var/local/osd1
    - ceph-deploy osd activate node2:/var/local/osd0 node3:/var/local/osd1

    - ceph-deploy admin admin-node node1 node2 node3
    - ceph-deploy --overwrite-conf config push admin-node node1 node2 node3
    - ceph -s
2. [admin-node] quick
    - sudo su;
    - cd /root/my-cluster
    - /usr/bin/ceph-deploy new node1; (has run by admin-node puppet code)
    - ceph-deploy install admin-node node1 node2 node3; ceph-deploy mon create-initial; ceph-deploy osd prepare node2:/var/local/osd0 node3:/var/local/osd1

    - [node 2] sudo chown ceph:ceph /var/local/osd0
    - [node 3] sudo chown ceph:ceph /var/local/osd1
    - ceph-deploy osd activate node2:/var/local/osd0 node3:/var/local/osd1; ceph-deploy admin admin-node node1 node2 node3; ceph-deploy --overwrite-conf config push admin-node node1 node2 node3; ceph -s
