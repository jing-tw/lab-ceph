#!/bin/bash
. ./clean.sh

kk=`cat Vagrantfile | grep config.ssh.insert_key| awk -F '[=]' '{gsub(/ /, "", $2);print $2}'`
if [ "$kk" != "false" ]; 
then
   echo "has_insert_key=$has_insert_key"
   echo "Error: The key has_insert_key should be false for create a public box. Exit!" 
   exit 1
fi

Gateway_Subnet=`ip r | grep default | cut -d ' ' -f 3|awk -F '[.]' '{printf "%s.%s.%s.\n",$1,$2,$3}'`
Gateway_Subnet=${Gateway_Subnet} vagrant up && vagrant halt

box_name="ceph-docker-box"
uuid=`vboxmanage list vms | grep $box_name | sed -r 's/.*\{(.*)\}/\1/'`
echo $uuid

rm $box_name'.box'
vagrant package --base $uuid --output $box_name'.box'

