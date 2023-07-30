

# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r

. ceph/host.conf

chmod +x ~/ceph/run-*.sh

~/ceph/run-kill.sh 

~/ceph/run-apt.sh 

# only on first node
~/ceph/run-conf-single.sh 
~/ceph/run-setup-key.sh 


# on all nodes
sh ~/ceph/run-conf.sh 
sh ~/ceph/set.sh 

~/ceph/run-setup-mon.sh 
~/ceph/run-setup-mds.sh 

