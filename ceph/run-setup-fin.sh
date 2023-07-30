
# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r


. ./ceph/host.conf

~/ceph/run-setup-osd.sh

~/ceph/run-setup-mgr.sh

#~/ceph/run-setup-fs.sh

sh ~/ceph/run-conf.sh 
sh ~/ceph/run-restart-all.sh

