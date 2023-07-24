#!/usr/bin/bash

. ./ceph/host.conf

# transver into cloud.vm
# dd if=run-install3.py |  ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i hz/cloud-key  root@5.75.235.244  -- dd of=run.sh
# execute in vm
# ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i hz/cloud-key  root@5.75.235.244  -- sh /root/run.sh


apt update -y
apt install -y ceph 
apt install -y screen nmap
apt install -y sudo vim htop screen 

