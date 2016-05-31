# ceph/daemon example
## Start Deployment
```bash
git clone https://github.com/jing-tw/lab-ceph.git
cd lab-ceph
git checkout ceph-docker

cd 3-host
. ./up.sh
```

## Test

### Login Ceph hosts
```bash
vagrant ssh host-1
vagrant ssh host-2
vagrant ssh host-3

```
## More Detail
Google doc: 
https://docs.google.com/document/d/1ZkG3X0RmwCHTiuu_3usYpoZRbxeHQhrZQ-54EhsQuL8/edit?usp=sharing

## Original
- tutorial: http://ceph.com/planet/bootstrap-your-ceph-cluster-in-docker/
- ceph/docker code: https://github.com/ceph/ceph-docker
- YouTube: https://www.youtube.com/watch?v=FUSTjTBA8f8

