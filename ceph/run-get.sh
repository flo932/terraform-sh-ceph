
. ./ceph/host.conf
#source /root/ceph/host.conf


#cat <<EOF > /root/get
echo ". ./ceph/host.conf"
echo "#########################"
echo "# conf from $node #######"
echo "# conf from $ip   #######"
echo "#########################"

#----------- show config's on screen to copy !

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


fn="/tmp/monmap"
echo "rm -rf $fn"
R=$(cat $fn | base64)
echo "echo '$R' | base64 -d > $fn"
echo




