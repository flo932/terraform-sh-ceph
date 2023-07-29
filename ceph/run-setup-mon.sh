


echo "create mon ------------------"
. ./ceph/host.conf

echo "#kill ceph-mon"
ps aux | grep ceph-mon | grep -v grep |  sed 's/[ ][ ]*/ /g' | cut -f 2 -d " " | xargs -i kill {}
#echo 'ps aux | grep ceph-mon | grep -v grep  | sed \\'s/[ ][ ]*/ /g\\' | cut -f 2 -d " " | xargs -i kill {}'


#monmaptool --create --add $node $ip --fsid $fsid /tmp/monmap --clobber

rm -rf /var/lib/ceph/mon/*
#touch /tmp/ceph.keyring
sudo -u ceph mkdir /var/lib/ceph/mon/ceph-$node
sudo -u ceph ceph-mon --mkfs -i $node --monmap /tmp/monmap --keyring /tmp/ceph.keyring
#cp /tmp/ceph.keyring /var/lib/ceph/mon/ceph-$node/keyring
cp /tmp/ceph.mon.keyring /var/lib/ceph/mon/ceph-$node/keyring

chown -R ceph:ceph /var/lib/ceph/mon/ceph-$node/


# run screen
#screen -m -d -S mon /usr/bin/ceph-mon -f --cluster ceph --id $node --setuser ceph --setgroup ceph -d
#echo 'screen -m -d -S mon /usr/bin/ceph-mon -f --cluster ceph --id $node --setuser ceph --setgroup ceph -d'

systemctl stop ceph-mon@$node

systemctl start ceph-mon@$node
systemctl enable ceph-mon@$node

systemctl status ceph-mon@$node

ceph mon enable-msgr2
