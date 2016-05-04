#!/bin/bash

strSubNet=$1

. ./common.sh


fun_get_public_ip $strSubNet
echo RstrSubNet=$strSubNet
echo strBridgedIP=$strBridgedIP

fun_install_docker

sudo docker run -d --name=mon --net=host \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph \
-e MON_IP=$strBridgedIP \
-e CEPH_PUBLIC_NETWORK=$strSubNet"0"/24 \
ceph/daemon mon

# copy key
sleep 30
rm -fr /vagrant/1; mkdir /vagrant/1
rm -fr /vagrant/2; mkdir /vagrant/2
sudo cp -fr /etc/ceph/* /vagrant/1/
sudo cp -fr /var/lib/ceph/* /vagrant/2/

echo "key copy completed"
#ls -la /vagrant/1
#ls -la /vagrant/2

# add osd
sudo docker run -d --name=osd1 --net=host \
--privileged=true \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph \
-v /dev/:/dev/ \
-e OSD_DEVICE=/dev/sdb \
-e OSD_FORCE_ZAP=1 \
ceph/daemon osd_ceph_disk

# RADOSGW should be installed when cluster is ready
# install radosgw
#sleep 10

# add radosgw 
# sudo docker run -d --net=host \
# -p 80:8080 \
#-v /var/lib/ceph/:/var/lib/ceph \
# -v /etc/ceph:/etc/ceph \
#ceph/daemon rgw

# test radosgw
# curl -v $strBridgedIP":8080"


