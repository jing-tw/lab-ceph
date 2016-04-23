#!/bin/bash

mkdir /etc/ceph
mkdir /var/lib/ceph

cp -fr ./1/* /etc/ceph/
cp -fr ./2/* /var/lib/ceph/
