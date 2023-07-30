
## test repo to create a 3 node ceph cluster in HETZNER-CLOUD
```
Hi.
With this repo I learn how to use Terraform on Hetzner-Cloud
and deploy a ceph 3-Node cluster with bash script's

deployed with python 
```

## first with terraform
```
# cd into terraform subdir hz or ht-min
cd hz
terraform init # one a time
python3 deploy.py
cd ..
```


# Info what deployment does on the VM'S
- deploy the node's 

## python3 deploy.py
- subdir ceph/run-* -> ssh -> vm
- apt install ceph 
- exec config in vm
- copy config from first node to other nodes
- run ceph-mon@$node

## check the nodes with
```
python3 terra-ssh.py 'md5sum /tmp/*'
python3 terra-ssh.py 'ps aux | grep ceph'
python3 terra-ssh.py 'source ./host.conf; echo $node'
python3 terra-ssh.py 'ceph -s' # timeout ?
```

## check if all run's
python3 terra-ssh 'ceph -s'
python3 terra-ssh 'ceph/run-ps.sh'
