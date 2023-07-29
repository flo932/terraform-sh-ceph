
ps aux | grep ceph | grep -v run- | grep -v grep |  sed 's/[ ][ ]*/ /g' | cut -f 2 -d " " | xargs -i -t kill {}
