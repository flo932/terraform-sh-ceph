#!/usr/bin/python3

import os
import time
import sys

def get_state():

    start = time.time()
    p = "./none/state.json"
    ok = 0
    for i in [".","..","../.."]:
        for d in os.listdir(i):
            #print(d)
            if not d.startswith("hz"):
                continue
            sp = i+"/"+d+"/ssh-key"
            print("-",sp)
            if os.path.isfile(sp):
                p = i+"/"+d+"/state.json"
                ok = 1
                break
        if ok:
            break

    cmd="cd {} ; terraform state pull > state.json".format(i+"/"+d)
    os.system(cmd)
    print()
    print(p)
    cmd="grep 'ip\|name' "+p
    print(cmd)
    r = os.popen(cmd)

    data = []
    data_name = []
    name = "xxx"
    ip = 0
    for line in r:
        line = line.strip()
        #print(line)
        if "ipv4_address" in line:
            ip = line.split()[1]
            ip = ip.replace(",","").replace('"','')
            print(ip)
            data.append(ip)
            name = ""

        if name == "" and "name" in line:
            name = line
            name = line.split()[1]
            name = name.replace(",","").replace('"','')
            print(name)
            data_name.append(name)
    return data,data_name


SSH = ' ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes"   root@{} '
if os.path.isfile("hz/ssh-key"):
    SSH = ' ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i hz/ssh-key  root@{} '
elif os.path.isfile("../hz/ssh-key"):
    SSH = 'ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i "../hz/ssh-key"  root@{} '

elif os.path.isfile("hz-min/ssh-key"):
    SSH = 'ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i "hz-min/ssh-key"  root@{} '
elif os.path.isfile("../hz-min/ssh-key"):
    SSH = 'ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i "../hz-min/ssh-key"  root@{} '


def ssh_exe(cmd,ip,name="<name>",mute=0):
    #print(os.getcwd())
    cmd=cmd.format(ip)
    if mute == 0:
        pass#print(cmd)
    r=os.popen(cmd)
    if mute == 0:
        #print("--",r)
        for line in r:
            print(line[:-1]) #.strip())
