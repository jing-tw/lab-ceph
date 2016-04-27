#!/bin/bash

vagrant destroy -f
rm -f ceph-docker-box.box
vagrant box remove -f ceph-docker-box
