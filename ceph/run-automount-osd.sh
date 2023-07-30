

FSID=$(cat /etc/ceph/ceph.conf | grep fsid | cut -f 4 -d " " )
echo "FSID '$FSID'"
echo 

DISK="/dev/sdb1"
umount /mnt/test
mkdir -p /mnt/test
mount $DISK /mnt/test
df -h | grep sdb
ID=$(cat /mnt/test/whoami)
xFSID=$(cat /mnt/test/ceph_fsid)
echo "$ID '$xFSID'"
umount /mnt/test

if [ "x$FSID" = "x$xFSID" ]; then
    echo "FSID OK $DISK"
    umount -l -f /var/lib/ceph/osd/ceph-$ID
    mount -o user_xattr $DISK /var/lib/ceph/osd/ceph-$ID
    
    screen -m -d -S osd-$ID /usr/bin/ceph-osd -f --id $ID --setuser ceph --setgroup ceph -d
else
    echo "no"
fi



DISK="/dev/sdc1"
umount /mnt/test
mkdir -p /mnt/test
mount $DISK /mnt/test
df -h | grep sdc
ID=$(cat /mnt/test/whoami)
xFSID=$(cat /mnt/test/ceph_fsid)
echo "$ID $xFSID"
umount /mnt/test
#/var/lib/ceph/osd/ceph-0/fsid


if [ "x$FSID" = "x$xFSID" ]; then
    echo "FSID OK $DISK"
    umount -l -f /var/lib/ceph/osd/ceph-$ID
    mount -o user_xattr $DISK /var/lib/ceph/osd/ceph-$ID
    
    screen -m -d -S osd-$ID /usr/bin/ceph-osd -f --id $ID --setuser ceph --setgroup ceph -d
else
    echo "no"
fi

