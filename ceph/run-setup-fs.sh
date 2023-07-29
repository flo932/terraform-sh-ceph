

. ./ceph/host.conf

ceph osd pool ls 

fs="ceph"
id=1

#create fs
ceph osd pool create ${fs}_rds $id
ceph osd pool create ${fs}_fs_data $id
ceph osd pool create ${fs}_fs_metadata $id
ceph fs new ${fs}fs ${fs}_fs_metadata ${fs}_fs_data

ceph osd stat
echo "ceph osd stat"
echo "ceph osd tree"

echo "ceph fs statuse"
echo "ceph fs ls"


echo "ceph mds stat"
echo "stat /sbin/mount.ceph"


echo "rbd pool init ${fs}_rds"


cp /tmp/ceph.keyring  /etc/ceph/ceph.client.foo.keyring

# mount  cephfs kernel 
#mount -t ceph cephuser@.cephfs=/ -o secret=AQATSKdNGBnwLhAAnNDKnH65FmVKpXZJVasUeQ==
#mount -t ceph :/ /mnt/mycephfs -o name=admin,fs=cephfs2
#mount -t ceph :/ /mnt/ -o name=admin,fs=cephfs2

# mount  cephfs fuse
#apt install -y ceph-fuse

#ceph-fuse --id foo /mnt/cephfs/ --no-mon-config
#ceph-fuse --id foo /mnt/cephfs/ --no-mon-config -k /tmp/ceph.keyring 


mkdir -p /mnt/cephfs
echo "ceph-fuse -d --id bootstrap-osd -k /tmp/ceph.keyring -m 10.0.1.5:6789 /mnt/cephfs/ &"
#ceph-fuse --id bootstrap-osd -k /tmp/ceph.keyring -m 10.0.1.5:6789 /mnt/cephfs/ 

#ceph-fuse -d --id admin -k /tmp/ceph.keyring -m 10.0.1.5:6789 /mnt/cephfs/ --no-mon-config
echo 'ceph-fuse --id admin -n client.admin -k /tmp/ceph.keyring -m 10.0.1.2:6789 /mnt/cephfs/ --no-mon-config'

