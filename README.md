
# test repo to create a 3 node ceph cluster in HETZNER-CLOUD

## first with terraform
```
cd hz
python3 create
cd ..
```

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

## setup ceph-mgr
osd and mgr is comming ...
- 
