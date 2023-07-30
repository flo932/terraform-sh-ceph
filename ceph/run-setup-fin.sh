
. ./ceph/host.conf

~/ceph/run-setup-osd.sh

~/ceph/run-setup-mgr.sh

#~/ceph/run-setup-fs.sh

sh ~/ceph/run-conf.sh 
sh ~/ceph/run-restart-all.sh

