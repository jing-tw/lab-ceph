# build ceph env
virtualenv env
. ./venv/bin/activate
source ./openstack.rc

. ./build-ceph-env.sh



# clean env
. ./remove-ceph-env.sh
