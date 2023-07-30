
# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r



. ./ceph/host.conf


fs="ceph"

ceph osd pool ls


# hang 's TODO
ceph osd pool create ${fs}_rds $id
echo "rbd pool init ${fs}_rds"
rbd pool init ${fs}_rds


ip="10.0.1.5"


# hang's TODO
sudo rbd create disk1 --size 4096 --image-feature layering -m $ip -k /etc/ceph/ceph.client.admin.keyring -p rbdpool

sudo rbd map disk1 --name client.admin -m $ip -k /etc/ceph/ceph.client.admin.keyring -p rbdpool

sudo mkfs.ext4 -m0 /dev/rbd/rbdpool/disk1
sudo mount /dev/rbd/rbdpool/disk1 /mnt/ceph-block-device

#fstab
#rbdpool/disk1           id=admin,keyring=/etc/ceph/ceph.client.admin.keyring


sudo systemctl start rbdmap
