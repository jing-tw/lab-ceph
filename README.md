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
1. ~/test/lab/lab-ceph/server$ vagrant up && vagrant ssh
2. ~/test/lab/lab-ceph/node1$ vagrant up && vagrant ssh
3. ~/test/lab/lab-ceph/node2$ vagrant up && vagrant ssh
4. ~/test/lab/lab-ceph/node3$ vagrant up && vagrant ssh

