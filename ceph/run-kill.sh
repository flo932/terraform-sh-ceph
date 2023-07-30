

# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r

ps aux | grep ceph | grep -v run- | grep -v grep |  sed 's/[ ][ ]*/ /g' | cut -f 2 -d " " | xargs -i -t kill {}
