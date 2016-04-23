#!/bin/bash

function fun_install_docker(){
    # for https transport
    [ -e /usr/lib/apt/methods/https ] || {
      apt-get -y update
      apt-get -y install apt-transport-https
    }

    # for apt-key
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

    # update the apt-repository
    sh -c "echo deb https://get.docker.io/ubuntu docker main\
> /etc/apt/sources.list.d/docker.list"
    apt-get -y update

    # install the docker
    apt-get -y install lxc-docker
}

function fun_get_ip(){
    strSubNet="192.168.0"

    strBridgedIP=$(ip addr | grep ${strSubNet} | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
    echo $strBridgedIP
}


fun_install_docker
fun_get_ip

docker run -d --net=host -v /etc/ceph:/etc/ceph -e MON_IP=$strBridgedIP -e CEPH_NETWORK=192.168.0.0/24 ceph/demo

