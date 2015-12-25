# lab-ceph

A test lab for deployment the ceph system at home

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
[admin-node]
    mkdir my-cluster
    cd my-cluster/
    ceph-deploy new node1
    vi ceph.conf 
    ceph-deploy install admin-node node1 node2 node3
    ceph-deploy mon create-initial
    ceph-deploy osd prepare node2:/var/local/osd0
