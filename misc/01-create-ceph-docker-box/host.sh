#!/bin/bash

# setup vagrant public key 
#wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O .ssh/authorized_keys
#chmod 700 .ssh
#chmod 600 .ssh/authorized_keys
#chown -R vagrant:vagrant .ssh

# normal
strSubNet=$1

. ./common.sh


fun_get_public_ip $strSubNet
echo RstrSubNet=$strSubNet
echo strBridgedIP=$strBridgedIP

fun_install_docker

docker pull ceph/daemon

echo "
docker run -d --net=host \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph \
-e MON_IP=$strBridgedIP \
-e CEPH_PUBLIC_NETWORK=$strSubNet"0"/24 \
ceph/daemon mon"
