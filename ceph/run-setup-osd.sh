#https://docs.ceph.com/en/latest/install/manual-deployment/


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

#sudo mkdir /var/lib/ceph/osd/ceph-$node
#sudo yes | mkfs -t ext4 /dev/sdb1
#sudo mount -o user_xattr /dev/sdb1 /var/lib/ceph/osd/ceph-$node/





UUID=$(uuidgen)

OSD_SECRET=$(ceph-authtool --gen-print-key)

ID=$(echo "{\"cephx_secret\": \"$OSD_SECRET\"}" |  ceph osd new $UUID -i - -n osd. -k /tmp/ceph.keyring)

mkdir /var/lib/ceph/osd/ceph-$ID
mount /dev/sdb1 /var/lib/ceph/osd/ceph-$ID

ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-$ID/keyring --name osd.$ID --add-key $OSD_SECRET


ceph-osd -i $ID --mkfs --osd-uuid $UUID

chown -R ceph:ceph /var/lib/ceph/osd/ceph-$ID

systemctl enable ceph-osd@$ID
systemctl start ceph-osd@$ID

sleep 2

systemctl status ceph-osd@$ID


