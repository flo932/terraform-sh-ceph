
. ./ceph/host.conf
#source /root/ceph/host.conf


#cat <<EOF > /root/get
echo ". ./ceph/host.conf"
echo "#########################"
echo "# conf from $node #######"
echo "# conf from $ip   #######"
echo "#########################"

#----------- show config's on screen to copy !

fn="/tmp/ceph.client.admin.keyring"
echo "rm -rf $fn"
echo "cat <<EOF > $fn"
cat $fn
echo "EOF"
echo "cp $fn /etc/ceph/"
echo

fn="/tmp/ceph.keyring"
echo "cat <<EOF > $fn "
cat $fn
echo "EOF"
echo

fn="/tmp/ceph.mon.keyring"
echo "rm -rf $fn"
echo "cat <<EOF > $fn"
cat $fn
echo "EOF"
echo 

fn="/tmp/monmap"
echo "rm -rf $fn"
R=$(cat $fn | base64)
echo "echo '$R' | base64 -d > $fn"
echo
