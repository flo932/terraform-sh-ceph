
echo "clenaup tmp ------------------"
node=abc0
ip=10.0.1.5

. ./ceph/host.conf

rm -rf /tmp/ceph.*
rm -rf /tmp/monmap

echo "kill all ceph"
ps aux | grep ceph | grep -v run- | grep -v grep |  sed 's/[ ][ ]*/ /g' | cut -f 2 -d " " | xargs -i -t kill {}

echo "genkey ------------------"
#sudo ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'

sudo ceph-authtool --create-keyring /tmp/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'

#ceph auth add mds.$node osd "allow rwx" mds "allow *" mon "allow profile mds" -i /tmp/ceph.mds.keyring
#sudo ceph-authtool --create-keyring /tmp/ceph.bootstrap-osd.keyring --gen-key -n client.bootstrap-osd --cap mon 'profile bootstrap-osd' --cap mgr 'allow r'
#ceph auth get-or-create mgr.$node mon 'allow profile mgr' osd 'allow *' mds 'allow *' >  /tmp/ceph.mgr.keyring

#ceph auth add osd.$node osd 'allow *' mon 'allow rwx' -i /tmp/ceph.osd.keyring

touch /tmp/ceph.keyring

sudo ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
sudo ceph-authtool --create-keyring /tmp/ceph.osd.keyring --gen-key -n osd. --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
sudo ceph-authtool --create-keyring /tmp/ceph.mgr.keyring --gen-key -n mgr. --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
sudo ceph-authtool --create-keyring /tmp/ceph.mds.keyring --gen-key -n mds. --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'

j=0
for i in $(echo $nodes | tr "," "\n")
do
    echo "gen mds KEY i1 $i $j "
    sudo ceph-authtool --create-keyring /tmp/ceph.mds.$i.keyring --gen-key -n mds.$i --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
    sudo ceph-authtool /tmp/ceph.keyring --import-keyring /tmp/ceph.mon.$i.keyring
    j=$((j+1))
done


cp /tmp/ceph.client.admin.keyring /etc/ceph/ceph.client.admin.keyring
cp /tmp/ceph.bootstrap-osd.keyring /var/lib/ceph/bootstrap-osd/ceph.keyring


monmaptool --create --add $node $ip --fsid $fsid /tmp/monmap #--clobber


sudo ceph-authtool /tmp/ceph.keyring --import-keyring /tmp/ceph.mon.keyring
sudo ceph-authtool /tmp/ceph.keyring --import-keyring /tmp/ceph.mgr.keyring
sudo ceph-authtool /tmp/ceph.keyring --import-keyring /tmp/ceph.mds.keyring
sudo ceph-authtool /tmp/ceph.keyring --import-keyring /tmp/ceph.osd.keyring
sudo ceph-authtool /tmp/ceph.keyring --import-keyring /tmp/ceph.client.admin.keyring
sudo ceph-authtool /tmp/ceph.keyring --import-keyring /tmp/ceph.bootstrap-osd.keyring


sudo chown ceph:ceph /tmp/ceph*keyring

echo "pause"
read

j=1
for i in $(echo $ips | tr "," "\n")
do
    k=$(echo $nodes | cut -f $j -d ",")
    monmaptool --add $k $i:6789 /tmp/monmap
    j=$((j+1))
done


monmaptool --print /tmp/monmap

