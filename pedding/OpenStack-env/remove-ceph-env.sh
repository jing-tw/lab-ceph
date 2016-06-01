#!/bin/bash

function wait_for_volume_available(){
    local vm_name=$1
    local volume_status=`cinder list | grep ${vm_name} | awk -F '[|]' '{print $3}'`

    while [[ "${volume_status}" == *in-use* ]]; do
        echo "Volume ${volume_status}, wait... "
        volume_status=`cinder list | grep ${vm_name} | awk -F '[|]' '{print $3}'`
    done
    echo "Volume is ready to delete."
}


nova delete jing-ceph-monitor
nova delete jing-ceph-osd1
nova delete jing-ceph-osd2

wait_for_volume_available vol_jing-ceph-monitor_5G
cinder delete vol_jing-ceph-monitor_5G
wait_for_volume_available vol_jing-ceph-osd1_5G
cinder delete vol_jing-ceph-osd1_5G
wait_for_volume_available vol_jing-ceph-osd2_5G
cinder delete vol_jing-ceph-osd2_5G
