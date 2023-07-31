
# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r



. ./ceph/host.conf
ceph -s

#ceph auth get-or-create mgr.$node mon 'allow profile mgr' osd 'allow *' mds 'allow *'
#ceph-mgr -i $node --no-mon-config

cat /tmp/ceph.keyfile

#ceph-mgr -i $node --no-mon-config --setuser ceph --setgroup ceph  -f  -k /tmp/ceph.keyring 
#ceph-mgr -i mgr.$node --no-mon-config --setuser ceph --setgroup ceph  -f  -k /tmp/ceph.keyring 
#ceph-mgr -i mgr. --no-mon-config --setuser ceph --setgroup ceph  -f  -k /tmp/ceph.keyring 
#ceph-mgr -i mgr.node0 -n client.admin --no-mon-config --setuser ceph --setgroup ceph -k /tmp/ceph.keyring

rm -rfv /var/lib/ceph/mgr/ceph-$node

mkdir -pv /var/lib/ceph/mgr/ceph-$node/

cp -va /tmp/ceph.mgr.$node.keyring /var/lib/ceph/mgr/ceph-$node/keyring
chown -R ceph:ceph /var/lib/ceph/mgr/ceph-$node
chmod -R 644 /var/lib/ceph/mgr/ceph-$node/
chmod +x /var/lib/ceph/mgr/ceph-$node

#sleep 1
echo "# start by hand"
echo "/usr/bin/ceph-mgr  -i mgr.$node  -n mgr.$node --setuser ceph --setgroup ceph -d  --no-mon-config  #--keyring /tmp/ceph.keyring"
echo 

#sleep 1
ps aux | grep -v grep | grep ceph

systemctl enable ceph-mgr@$node 
systemctl start ceph-mgr@$node 
sleep 2
systemctl status ceph-mgr@$node 

exit 











. ./ceph/host.conf


mkdir -p /var/lib/ceph/mds/ceph-$node

ceph-authtool --create-keyring /var/lib/ceph/mds/ceph-$node/keyring --gen-key -n mds.$node


ceph auth add mds.$node osd "allow rwx" mds "allow *" mon "allow profile mds" -i /var/lib/ceph/mds/ceph-$node/keyring


echo
ceph-mds --cluster ceph -i $node -m 10.0.1.5 --no-mon-config

systemctl start ceph-mds@$node 
sleep 2
systemctl status ceph-mds@$node 


sleep 2
echo
ps aux | grep -v grep | grep ceph 



