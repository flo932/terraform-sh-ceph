
. ./ceph/host.conf




systemctl stop ceph@$node
systemctl stop ceph-mon@$node
systemctl stop ceph-mgr@$node
systemctl stop ceph-mds@$node
systemctl stop ceph-osd@$node

echo "kill all ceph"
ps aux | grep ceph | grep -v run- | grep -v grep |  sed 's/[ ][ ]*/ /g' | cut -f 2 -d " " | xargs -i -t kill {}



systemctl start ceph@$node
systemctl start ceph-mon@$node
systemctl start ceph-mgr@$node
systemctl start ceph-mds@$node
systemctl start ceph-osd@$node


sleep 2

systemctl status ceph@$node
systemctl status ceph-mon@$node
systemctl status ceph-mgr@$node
systemctl status ceph-mds@$node
systemctl status ceph-osd@$node
