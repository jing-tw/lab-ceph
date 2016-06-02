#!/bin/bash

# add mds server on host-1
vagrant ssh host-1 -c "sudo docker run -d --restart=always --name=mds-$RANDOM --net=host \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph \
-e CEPHFS_CREATE=1 \
ceph/daemon mds"

# check stats
vagrant ssh host-1 -c "sudo docker ps"
vagrant ssh host-1 -c "sudo docker exec mon ceph mds stat"

# show how to mount
echo "How to mount cephfs system"
echo "============================="
echo "Step 1: [ceph node] cat /etc/ceph/ceph.client.admin.keyring > admin.secret"
echo "Step 2: [any ubuntu] sudo apt-get install ceph-common ceph-fs-common"
echo "Step 3: [any ubuntu] sudo mount -t ceph MONITOR_IP:6789:/ /mnt/mycephfs -o name=admin,secretfile=admin.secret"
echo "Detail: https://docs.google.com/document/d/1EzcPg2UQytJgOBcKxJqdVtKOsB1whK52dKZRY6DHZLk/edit?usp=sharing"
vagrant ssh host-1 -c "sudo cat /etc/ceph/ceph.client.admin.keyring | grep key"
echo "============================"

