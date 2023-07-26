
. ./ceph/host.conf


apt install -y ceph-mds

echo "mds Metadata's"
#ceph-mds --cluster {cluster-name} -i {id} -m {mon-hostname}:{mon-port} [-f]

mkdir -p /var/lib/ceph/mds/ceph-$nodes

cp /tmp/ceph.keyring /var/lib/ceph/mds/ceph-$node/keyring
#ceph-authtool --create-keyring /var/lib/ceph/mds/ceph-$node/keyring --gen-key -n mds.$node

ceph auth add mds.$node osd "allow rwx" mds "allow *" mon "allow profile mds" -i /var/lib/ceph/mds/ceph-$node/keyring

systemctl status ceph-mds@$node
systemctl enable ceph-mds@$node
systemctl start ceph-mds@$node
systemctl status ceph-mds@$node


