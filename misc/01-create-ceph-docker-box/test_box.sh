#!/bin/bash

# ==== import the box ====
vagrant box add --name ceph-docker-box ceph-docker-box.box
# check
ls ~/.vagrant.d/boxes/

# == Usage ====
mkdir test_box
cd test_box

vagrant init ceph-docker-box
# setup network (ex: bridge)
vagrant up
