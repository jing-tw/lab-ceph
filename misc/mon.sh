#!/bin/bash
. ./common.sh

strSubNet="192.168.1."
fun_get_public_ip $strSubNet

echo "strBridgedIP=$strBridgedIP"
echo $strSubNet"0"/24
sudo docker run -d --net=host \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph \
-e MON_IP=$strBridgedIP \
-e CEPH_PUBLIC_NETWORK=$strSubNet"0"/24 \
ceph/daemon mon

sleep 10
sudo docker ps 
