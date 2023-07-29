
. ./ceph/host.conf




systemctl stop ceph@$node
systemctl stop ceph-mon@$node
systemctl stop ceph-mgr@$node
systemctl stop ceph-mds@$node

systemctl stop ceph-osd@1
systemctl stop ceph-osd@2
systemctl stop ceph-osd@3
systemctl stop ceph-osd@4

echo "kill all ceph"
ps aux | grep ceph | grep -v run- | grep -v grep |  sed 's/[ ][ ]*/ /g' | cut -f 2 -d " " | xargs -i -t kill {}



systemctl start ceph@$node
systemctl start ceph-mon@$node
systemctl start ceph-mgr@$node
systemctl start ceph-mds@$node

systemctl start ceph-osd@1
systemctl start ceph-osd@2
systemctl start ceph-osd@3
systemctl start ceph-osd@4


sleep 2

systemctl status ceph@$node
systemctl status ceph-mon@$node
systemctl status ceph-mgr@$node
systemctl status ceph-mds@$node

systemctl status ceph-osd@1
systemctl status ceph-osd@2
systemctl status ceph-osd@3
systemctl status ceph-osd@4
