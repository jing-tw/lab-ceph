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

sudo docker run -d --restart=always --name=mon --net=host \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph \
-e MON_IP=$strBridgedIP \
-e CEPH_PUBLIC_NETWORK=$strSubNet"0"/24 \
ceph/daemon mon

# add osd
sudo docker run -d --restart=always --name=osd --net=host \
--privileged=true \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph \
-v /dev/:/dev/ \
-e OSD_DEVICE=/dev/sdb \
-e OSD_FORCE_ZAP=1 \
ceph/daemon osd_ceph_disk

sleep 10

# add radowgw server
docker run -d --restart=always --net=host \
-v /var/lib/ceph/:/var/lib/ceph \
-v /etc/ceph:/etc/ceph \
ceph/daemon rgw

echo ===========================
echo Verify radosgw
echo curl -v $strBridgedIP":8080"
echo  
