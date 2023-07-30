

# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r

. ./ceph/host.conf
#source /root/ceph/host.conf


#cat <<EOF > /root/get
echo ". ./ceph/host.conf"
echo "#########################"
echo "# conf from $node #######"
echo "# conf from $ip   #######"
echo "#########################"

#----------- show config's on screen to copy !
echo "rm -rf /tmp/ceph.*"
echo "rm -rf /tmp/monmap"

echo
j=0
LS=$(ls /tmp/ | grep ceph.*.keyring )
for i in $(echo $LS | tr " " "\n")
do
    fn="/tmp/$i"
    echo "cat <<EOF > $fn "
    cat $fn
    echo "EOF"
    echo
    #echo "------------get $i $j "
    j=$((j+1))
done
echo


fn="/tmp/monmap"
echo "rm -rf $fn"
R=$(cat $fn | base64)
echo "echo '$R' | base64 -d > $fn"
echo


echo
cp -va /tmp/ceph.client.admin.keyring /etc/ceph/ceph.client.admin.keyring
cp -va /tmp/ceph.bootstrap-osd.keyring /var/lib/ceph/bootstrap-osd/ceph.keyring
echo "cp -va /tmp/ceph.client.admin.keyring /etc/ceph/ceph.client.admin.keyring"
echo "cp -va /tmp/ceph.bootstrap-osd.keyring /var/lib/ceph/bootstrap-osd/ceph.keyring"

echo
chown -R ceph:ceph /tmp/ceph.* 
echo "chown -R ceph:ceph /tmp/ceph.* "


