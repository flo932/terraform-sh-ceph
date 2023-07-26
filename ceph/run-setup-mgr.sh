


. ./ceph/host.conf


echo "configuring manager"
rm -rf /var/lib/ceph/mgr/*

mkdir -p /var/lib/ceph/mgr/ceph-$node/
cp /tmp/ceph.keyring /var/lib/ceph/mgr/ceph-$node/keyring
chown -R ceph:ceph /var/lib/ceph/mgr/

#ceph auth get-or-create mgr.$node mon 'allow profile mgr' osd 'allow *' mds 'allow *' | tee  
#cp /tmp/ceph.mgr.keyring /var/lib/ceph/mgr/ceph-$node/keyring
#cp /tmp/ceph.keyring /var/lib/ceph/mgr/ceph-$node/keyring
ceph auth get-or-create mgr.$node mon 'allow profile mgr' osd 'allow *' mds 'allow *' -i /tmp/ceph.keyring  


chown ceph:ceph /var/lib/ceph/mgr/

ceph-mgr -i $node --no-mon-config
#ceph-mgr -i $node --no-mon-config -d
sleep 1

ceph -s

