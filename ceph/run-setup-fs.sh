

. ./ceph/host.conf

ceph osd pool ls 

fs="aAa"
id=1

#create fs
ceph osd pool create ${fs}fs_data $id
ceph osd pool create ${fs}fs_metadata $id
ceph fs new ${fs}fs ${fs}fs_metadata ${fs}fs_data

ceph osd stat
ceph osd tree

ceph fs status
ceph fs ls

ceph mds stat
stat /sbin/mount.ceph

cp /tmp/ceph.keyring  /etc/ceph/ceph.client.foo.keyring

# mount  cephfs kernel 
#mount -t ceph cephuser@.cephfs=/ -o secret=AQATSKdNGBnwLhAAnNDKnH65FmVKpXZJVasUeQ==
#mount -t ceph :/ /mnt/mycephfs -o name=admin,fs=cephfs2
#mount -t ceph :/ /mnt/ -o name=admin,fs=cephfs2

# mount  cephfs fuse
apt install -y ceph-fuse

#ceph-fuse --id foo /mnt/cephfs/ --no-mon-config
#ceph-fuse --id foo /mnt/cephfs/ --no-mon-config -k /tmp/ceph.keyring 


mkdir -p /mnt/cephfs
echo "ceph-fuse -d --id bootstrap-osd -k /tmp/ceph.keyring -m 10.0.1.5:6789 /mnt/cephfs/ &"
#ceph-fuse --id bootstrap-osd -k /tmp/ceph.keyring -m 10.0.1.5:6789 /mnt/cephfs/ 

#ceph-fuse -d --id admin -k /tmp/ceph.keyring -m 10.0.1.5:6789 /mnt/cephfs/ --no-mon-config
ceph-fuse --id admin -n client.admin -k /tmp/ceph.keyring -m 10.0.1.2:6789 /mnt/cephfs/ --no-mon-config

