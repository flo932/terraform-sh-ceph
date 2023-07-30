

echo "# ps aux | grep ceph"
ps aux | grep -v grep  | grep -v run-ps | grep ceph
echo 
