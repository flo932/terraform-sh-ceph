#!/usr/bin/python3

import os
import time
import sys

def get_state():

    start = time.time()
    cmd="grep 'ip\|name' ../hz/state.json"
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


def ssh_exe(cmd,ip,name="<name>",mute=0):
    print(os.getcwd())
    cmd=cmd.format(ip)
    if mute == 0:
        print(cmd)
    r=os.popen(cmd)
    if mute == 0:
        print("--",r)
        for line in r:
            print(line[:-1]) #.strip())
