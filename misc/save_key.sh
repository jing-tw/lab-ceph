#!/bin/bash

rm -fr ./1; mkdir 1
rm -fr ./2; mkdir 2
cp -fr /etc/ceph/* ./1
cp -fr /var/lib/ceph/* ./2
