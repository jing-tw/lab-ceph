#!/bin/bash
# Function: create_volume
# Usage:
#    create_volume vm_name size volume_type
# Return:
#    0: Success
#    1: Fail
function create_volume(){
    local vm_name=$1
    local size=$2
    local volume_type=$3

    if [ -z "$vm_name" ]; then
        echo "Usage: . ./create_volume vm_name size"
        return 1
    fi

    local display_name="vol_${vm_name}_${size}G"
    cinder create $size --display-name $display_name --volume-type ${volume_type}
}


# Function: attach_volume_to_vm
# Usage:
#     attach_volume_to_vm ABC
# Return:
#    0: success
#    1: fail
function attach_volume_to_vm(){
    vm_name=$1
    if [ -z "$vm_name" ]; then
        echo "Usage: . ./attach_volume vm_name"
        return 1
    fi

    echo vm_name=$vm_name
    vm_id=`nova list | grep ${vm_name} | awk -F '[|]' '{print $2}'`
    if [ -z "$vm_id" ]; then
        echo "VM does not found! please check command: nova list "
        return 1
    fi

    volume_id=`cinder list | grep ${vm_name} | awk -F '[|]' '{print $2}'`
    if [ -z "$volume_id" ]; then
        echo "Volume does not found! please check command: cinder list "
        return 1
    fi

    echo vm_id=${vm_id} 
    echo volume_id=${volume_id}
    nova volume-attach $vm_id $volume_id "/dev/vdc"
}

# Function: create_attach
# Usage:
#     create_attach vm_name size_in_GB volumes_ceph
function simple_volume_create_attach(){
    local vm_name=$1
    local size=$2
    local volume_type=$3
    create_volume $vm_name $size $volume_type
    attach_volume_to_vm $vm_name

    echo vm=${vm_name}
    echo ip=`nova list | grep ${vm_name} | awk -F '[|]' '{print $7}'`
    echo new_volume=${size}GB
}

function wait_for_VM_active(){
    local vm_name=$1
    local vm_status=`nova list | grep ${vm_name} | awk -F '[|]' '{print $4}'`

    while [[ "${vm_status}" != *ACTIVE* ]]; do
        vm_status=`nova list | grep ${vm_name} | awk -F '[|]' '{print $4}'`
        echo "Vm is ${vm_status}"
    done
    echo "VM ${vm_name} is ACTIVE."
}

vm_name=jing-ceph-monitor
size_in_GB=5
volumes_type=volumes_ceph
nova boot --image "ubuntu_cloud"  --key-name jing-key --flavor "m1.small" --availability-zone "node10" --user-data docker-ready.txt ${vm_name} --nic net-id=fc48a1d5-62e9-459f-89ab-86f4c0bf6486
wait_for_VM_active ${vm_name}
simple_volume_create_attach ${vm_name} ${size_in_GB} ${volumes_type}




vm_name=jing-ceph-osd1
size_in_GB=5
volumes_type=volumes_ceph
nova boot --image "ubuntu_cloud"  --key-name jing-key --flavor "m1.small" --availability-zone "node10" --user-data docker-ready.txt ${vm_name} --nic net-id=fc48a1d5-62e9-459f-89ab-86f4c0bf6486
wait_for_VM_active ${vm_name}
simple_volume_create_attach ${vm_name} ${size_in_GB} ${volumes_type}



vm_name=jing-ceph-osd2
size_in_GB=5
volumes_type=volumes_ceph
nova boot --image "ubuntu_cloud"  --key-name jing-key --flavor "m1.small" --availability-zone "node10" --user-data docker-ready.txt ${vm_name} --nic net-id=fc48a1d5-62e9-459f-89ab-86f4c0bf6486
wait_for_VM_active ${vm_name}
simple_volume_create_attach ${vm_name} ${size_in_GB} ${volumes_type}

