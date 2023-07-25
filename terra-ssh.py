#!/usr/bin/python3

import os
import time

cmd="cd hz; terraform state pull > state.json"
print(cmd)
os.system(cmd)

start = time.time()
cmd="grep 'ip\|name' hz/state.json"
print(cmd)
r = os.popen(cmd)

data = []
for line in r:
    line = line.strip()
    #print(line)
    if "ipv4_address" in line:
        print("-")
        ip = line.split()[1]
        ip = ip.replace(",","").replace('"','')
        print([ip])
        data.append(ip)
        print("time:",round(time.time()-start,2))       

SSH = ' ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i hz/ssh-key  root@{} '
def go(cmd,ip,name="<name>",mute=0):
    print(os.getcwd())
    cmd=cmd.format(ip)
    if mute == 0:
        print(cmd)
    r=os.popen(cmd)
    if mute == 0:
        print("--",r)
        for line in r:
            print(line.strip())

print()
import sys
for line in data:
    print(line)

    ip = line
    print(sys.argv)


    cmd=SSH+' -- \'{}\''
    cmd=cmd.format(ip,sys.argv[1])
    print(cmd)
    os.system(cmd)

