
. ./ceph/host.conf

find_osd=$(df -h | grep osd | grep sdb)
if [ "find_osd" = "" ];
then
   echo "NO OSD ... "
else
   echo "OSD detectet "
   # ! exit !"
   #exit
fi


df -h
umount -l -f /dev/sdb
umount -l -f /dev/sdb1
umount -l -f /dev/sdb2
wipefs -a  /dev/sdb
sync
sync
sync
sleep 1

(
echo g # Create a new empty GPT partition table
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk /dev/sdb


yes y | mkfs.ext4  /dev/sdb1

sync
sync
sync

sleep 1
partprobe

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
#ceph-osd -i $oid --mkfs --mkkey

sudo chown -R ceph:ceph /var/lib/ceph/osd

ceph-osd -i $oid --mkfs --mkkey  --osd-data /var/lib/ceph/osd/ceph-$node/ --monmap /tmp/monmap --no-mon-config

ceph auth add osd.$node osd 'allow *' mon 'allow rwx' -i /var/lib/ceph/osd/ceph-$node/keyring

ceph osd pool create $node-pool 3
#rbd create myBLock -p x --size 1024

ceph osd tree
ceph osd stat


