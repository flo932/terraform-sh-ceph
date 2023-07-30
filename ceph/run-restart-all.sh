. ./ceph/host.conf




systemctl stop ceph@$node
systemctl stop ceph-mon@$node
systemctl stop ceph-mgr@$node
systemctl stop ceph-mds@$node


OSDS=$(df | grep ceph |   cut -f 2 -d '-')
for i in $(echo $OSDS | tr "," "\n")
do
    cmd="systemctl stop ceph-osd@$i"
    echo $cmd
    $cmd
done



echo "kill all ceph"
ps aux | grep ceph | grep -v run- | grep -v grep |  sed 's/[ ][ ]*/ /g' | cut -f 2 -d " " | xargs -i -t kill {}



systemctl start ceph@$node
systemctl start ceph-mon@$node
systemctl start ceph-mgr@$node
systemctl start ceph-mds@$node

for i in $(echo $OSDS | tr "," "\n")
do
    cmd="systemctl start ceph-osd@$i"
    echo $cmd
    $cmd
done


sleep 2

systemctl status ceph@$node
systemctl status ceph-mon@$node
systemctl status ceph-mgr@$node
systemctl status ceph-mds@$node


for i in $(echo $OSDS | tr "," "\n")
do
    cmd="systemctl status ceph-osd@$i"
    echo $cmd
    $cmd
done

