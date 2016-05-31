#!/bin/bash

function timer()
{
    if [[ $# -eq 0 ]]; then
        echo $(date '+%s')
    else
        local  stime=$1
        etime=$(date '+%s')

        if [[ -z "$stime" ]]; then stime=$etime; fi

        dt=$((etime - stime))
        ds=$((dt % 60))
        dm=$(((dt / 60) % 60))
        dh=$((dt / 3600))
        printf '%d:%02d:%02d' $dh $dm $ds
    fi
}

tmr=$(timer)
Gateway_Subnet=`ip r | grep default | cut -d ' ' -f 3|awk -F '[.]' '{printf "%s.%s.%s.\n",$1,$2,$3}'`
Gateway_Subnet=${Gateway_Subnet} vagrant up

# enable csphfs
. ./enable_cephfs.sh | sed "s/^/[enable_cephfs.sh] /"

echo ===========================
echo Verify Ceph Healthy
vagrant ssh host-1 -c "sudo docker ps"
vagrant ssh host-1 -c "sudo docker exec -i -t mon ceph -s"
echo 
echo Login Ceph hosts
echo  vagrant ssh host-1
echo  vagrant ssh host-2
echo  vagrant ssh host-3

echo "Elapsed time:$(timer $tmr)"
