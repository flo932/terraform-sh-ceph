
## Deploy 3-node ceph cluster in HETZNER-CLOUD
```
Hi.
With this repo I learn how to use Terraform on Hetzner-Cloud
and deploy a ceph 3-Node cluster with bash script's

terraform and bash scripts 
are deployed with python3 to the VM's

Processes are: ceph-mon, ceph-osd, ceph-mgr, ceph-crush

i run in some none starting processes witout any error messages
solution: chmod,chown of keyring in /var/lib/ceph/[mon,osd,mgr]/keyring
```

## first deploy VM's with terraform
```
# cd into terraform subdir hz or hz-min
cd hz

# set hcloud_token , terraform.tfvars (option)

terraform init # one time

# create ssh-keys and deploy terraform
python3 deploy.py
cd ..
```


## first deploy VM's with terraform
```
# cd into terraform subdir hz or ht-min
cd hz
terraform init # one a time
python3 deploy.py
cd ..
```

---
---


# Explain 
- deploy the node's 

## python3 deploy.py
- subdir ceph/run-* -> ssh -> vm
- apt install ceph 
- generate CEPH config+key in first-vm
- copy config from first node to other nodes
- run ceph-mon@$node

## check the nodes with
```
python3 terra-ssh.py 'md5sum /tmp/*'
python3 terra-ssh.py 'source ./host.conf; echo $node'
python3 terra-ssh 'ceph/run-ps.sh'
python3 terra-ssh.py 'ceph -s' # timeout ?
```

