
. ./ceph/host.conf

df -h
umount -l -f /dev/sdb
umount -l -f /dev/sdb1
umount -l -f /dev/sdb2
wipefs -a  /dev/sdb

(
echo g # Create a new empty GPT partition table
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk /dev/sdb

mkfs ext4 /dev/sdb1
sync
sync
sync

partprobe
sleep 1

uuid=$(sudo blkid | grep sdb1 | cut -f 5-99 -d "=" | cut -d '"' -f 2)
if [ "$uuid" = "" ];
then
    uuid=$(sudo blkid | grep sdb1 | cut -f 2-99 -d "=" | cut -d '"' -f 2)
fi

echo
echo "UUID: $uuid"
echo 


if [ "$uuid" = "" ];
then
   echo "NO UUID FROM sdb1 !!!"
   exit
else
   echo ""
fi

sudo mkdir /var/lib/ceph/osd/ceph-$node
sudo yes | mkfs -t ext4 /dev/sdb1
sudo mount -o user_xattr /dev/sdb1 /var/lib/ceph/osd/ceph-$node/

cp /tmp/ceph.keyring  /var/lib/ceph/osd/ceph-$node/keyring
oid=$(ceph osd create $uuid)
echo "OID: $oid"
ceph-osd -i $oid --mkfs --mkkey


exit

#https://docs.ceph.com/en/latest/rados/operations/add-or-rm-osds/


umount /dev/sdb
#echo 'type=83' | sudo sfdisk /dev/sdb
wipefs /dev/sdb -a
cfdisk /dev/sdb
blkid


