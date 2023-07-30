

# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r

 
. ./ceph/host.conf

systemctl stop ceph-mon@$node

screen -S mon -X quit
ps aux | grep ceph-mon | grep -v grep | sed 's/[ ][ ]*/ /g' | cut -f 2 -d " "  | xargs -i kill {}
#echo "ps aux | grep ceph-mon | grep -v grep | cut -f 6-8 -d " " | xargs -i kill {}"
#screen -m -d -S mon /usr/bin/ceph-mon -f --cluster ceph --id $node --setuser ceph --setgroup ceph -d
sleep 2
screen -ls
 
