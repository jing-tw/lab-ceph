#!/bin/bash

sudo docker run -d --net=host \
--privileged=true \
-v /etc/ceph:/etc/ceph \
-v /var/lib/ceph/:/var/lib/ceph \
-v /dev/:/dev/ \
-e OSD_DEVICE=/dev/sdb \
-e OSD_FORCE_ZAP=1 \
ceph/daemon osd_ceph_disk
