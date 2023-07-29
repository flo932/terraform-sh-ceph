
chmod +x ~/ceph/run-*.sh

~/ceph/run-kill.sh 

~/ceph/run-apt.sh 

# only on first node
#~/ceph/run-conf-single.sh 
#~/ceph/run-setup-key.sh 


# on all nodes
sh ~/ceph/run-conf.sh 
sh ~/ceph/set.sh 

~/ceph/run-setup-mon.sh 
#~/ceph/run-setup-mgr.sh 
~/ceph/run-setup-mds.sh 
#~/ceph/run-setup-dash.sh 
#~/ceph/run-setup-osd.sh

#~/ceph/run-setup-fs.sh

