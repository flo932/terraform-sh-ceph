#!/usr/bin/bash

# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r


. ./ceph/host.conf

# transver into cloud.vm
# dd if=run-install3.py |  ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i hz/cloud-key  root@5.75.235.244  -- dd of=run.sh
# execute in vm
# ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i hz/cloud-key  root@5.75.235.244  -- sh /root/run.sh
X=$(ls /tmp/ | grep apt-ok)
echo "X=$X"
if [ "x" = "x$X" ]; then
    echo "no"
else
    echo "apt-ok"
    exit
fi

apt update -y
apt install -y ceph
apt install -y screen nmap
apt install -y sudo vim htop screen

apt install -y ceph-mds
apt install -y ceph-fuse

touch /tmp/apt-ok

