#https://docs.ceph.com/en/latest/install/manual-deployment/

# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r



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


systemctl stop ceph-osd

df -h
umount -l -f /dev/sdb    2>&1 > /dev/null 
umount -l -f /dev/sdb1   2>&1 > /dev/null  
umount -l -f /dev/sdb2   2>&1 > /dev/null 
umount -l -f /var/lib/ceph/osd/*
sleep 1;
wipefs -a  /dev/sdb1   2>&1 > /dev/null 
wipefs -a  /dev/sdb    2>&1 > /dev/null 
sync
sync
sync
sleep 1;

(
echo g # Create a new empty GPT partition table
echo n # Add a new partition
#echo p # Primary partition
echo   # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk /dev/sdb &> /dev/null

sync
sync
sleep 1
sync

mkfs.ext4 -F /dev/sdb1
sync
sync
sleep 1
sync
mkfs.ext4 -F /dev/sdb1

echo "---------------------------- OK "

sync
sync
sleep 1
sync

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


UUID=$(uuidgen)

OSD_SECRET=$(ceph-authtool --gen-print-key)

ID=$(echo "{\"cephx_secret\": \"$OSD_SECRET\"}" |  ceph osd new $UUID -i - -n osd. -k /tmp/ceph.keyring)
if [ "x" = "x$ID" ]; then
    echo "EXIT: NO OSD-ID !"
    exit 1
fi


echo "re-create /var/lib/ceph/osd/ceph-$ID"
rm -rf /var/lib/ceph/osd/ceph-$ID
mkdir /var/lib/ceph/osd/ceph-$ID
mount -o user_xattr /dev/sdb1 /var/lib/ceph/osd/ceph-$ID

echo "ceph-authtool osd.$ID"
ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-$ID/keyring --name osd.$ID --add-key $OSD_SECRET

echo "ceph-osd -i $ID --mkfs $UUID"
ceph-osd -i $ID --mkfs --osd-uuid $UUID

chown -R ceph:ceph /var/lib/ceph/osd/ceph-$ID

systemctl enable ceph-osd@$ID
systemctl start ceph-osd@$ID

sleep 2

systemctl status ceph-osd@$ID

#touch /var/spool/cron/crontabs/root
#chown root:crontab /var/spool/cron/crontabs/root
#chmod 600 /var/spool/cron/crontabs/root
echo "@reboot sleep 2; /root/ceph/run-automount-osd.sh" >  crontab.tmp
crontab crontab.tmp
crontab -l
systemctl enable cront
systemctl start cront
#cat  /var/spool/cron/crontabs/root



