#!/usr/bin/sh

# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r


. ./ceph/host.conf

######
#node="abc0"
#ip="10.0.1.5"

cat <<EOF > /etc/ceph/ceph.conf
[global]
 fsid = $fsid
 mon_initial_members = $node
 mon_host = $ip  
# mon_initial_members = $nodes
# mon_host = $ips
 public_network = $pubnet
 auth_cluster_required = cephx
 auth_service_required = cephx
 auth_client_required = cephx
 osd_pool_default_size = 3
 osd_pool_default_min_size = 2
 osd_pool_default_pg_num = 333
 osd_crush_chooseleaf_type = 1

EOF

