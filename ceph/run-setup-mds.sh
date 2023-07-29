
. ./ceph/host.conf


#apt install -y ceph-mds

echo "mds Metadata's"
#ceph-mds --cluster {cluster-name} -i {id} -m {mon-hostname}:{mon-port} [-f]

rm -rf /var/lib/ceph/mds/ceph-$node
mkdir -p /var/lib/ceph/mds/ceph-$node

#cp /tmp/ceph.keyring /var/lib/ceph/mds/ceph-$node/keyring
ceph-authtool --create-keyring /var/lib/ceph/mds/ceph-$node/keyring --gen-key -n mds.$node

#ceph auth add mds.$node osd "allow rwx" mds "allow *" mon "allow profile mds" -i /var/lib/ceph/mds/ceph-$node/keyring
#ceph auth add mds. osd "allow rwx" mds "allow *" mon "allow profile mds" -i /var/lib/ceph/mds/ceph-$node/keyring
ceph auth add mds.$node osd "allow rwx" mds "allow *" mon "allow profile mds" -i /var/lib/ceph/mds/ceph-$node/keyring

chown -R ceph:ceph /var/lib/ceph/mds/*

systemctl status ceph-mds@$node
systemctl enable ceph-mds@$node
systemctl start ceph-mds@$node
sleep 1
systemctl status ceph-mds@$node


