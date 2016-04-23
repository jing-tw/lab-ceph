#!/bin/bash

strSubNet=$1

. ./common.sh


fun_get_public_ip $strSubNet
echo RstrSubNet=$strSubNet
echo strBridgedIP=$strBridgedIP

fun_install_docker

# restore key
sudo mkdir /etc/ceph
sudo mkdir /var/lib/ceph
sudo cp -fr /vagrant/1/* /etc/ceph/
sudo cp -fr /vagrant/2/* /var/lib/ceph/

sudo docker run -d --net=host \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph \
-e MON_IP=$strBridgedIP \
-e CEPH_PUBLIC_NETWORK=$strSubNet"0"/24 \
ceph/daemon mon


