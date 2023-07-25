

. ./ceph/host.conf

# https://docs.ceph.com/en/quincy/mgr/dashboard/#enabling

apt install ceph-mgr-dashboard
# ceph dashboard create-self-signed-cer

ceph mgr module enable dashboard
#https://ceph-mgr:8443 or https://192.168.1.10:8443

# set password
echo "Start123!" > pw ; ceph dashboard ac-user-create Admin -i pw administrator
