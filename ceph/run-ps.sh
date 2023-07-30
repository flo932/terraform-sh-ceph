


# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r

echo "# ps aux | grep ceph"
ps aux | grep -v grep  | grep -v run-ps | grep ceph
echo 
