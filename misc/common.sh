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

function fun_get_public_ip(){
    strSubNet=$1
    if [ -z "$strSubNet" ]; then
        echo "strSubNet is empty. Do you run with . ./vagrant_up.sh?"
        exit
    fi


    echo strSubNet=$strSubNet
    strBridgedIP=$(ip addr | grep ${strSubNet} | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
    if [ -z "$strBridgedIP" ]; then
        echo "strBridgedIP is empty."
        exit
    fi
    echo strBridgedIP=$strBridgedIP
}

function fun_mon(){
    IP=$1
    SUBNET=$2

    sudo docker run -d --net=host \
    -v /etc/ceph:/etc/ceph \
    -v /var/lib/ceph/:/var/lib/ceph \
    -e MON_IP=$IP \
    -e CEPH_PUBLIC_NETWORK=$SUBNET/24 \
    ceph/daemon mon

    sleep 10
    sudo docker ps 
}

function fun_save_key(){

# vagrant way
    share_folder=/vagrant
    cd $share_folder

    rm -fr ./1 
    mkdir ./1
    rm -fr ./2 
    mkdir ./2
    cp -fr /etc/ceph/* ./1
    cp -fr /var/lib/ceph/* ./2

    cd ~
}

function fun_restore_key(){
    mkdir /etc/ceph
    mkdir /var/lib/ceph

    # vagrant way
    share_folder=/vagrant
    cd $share_folder

    cp -fr ./1/* /etc/ceph/
    cp -fr ./2/* /var/lib/ceph/

    cd ~
}
