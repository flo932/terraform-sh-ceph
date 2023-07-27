#!/usr/bin/python3

import os
import time

#cmd="cd hz; terraform state pull > state.json"
#print(cmd)
#os.system(cmd)
#
#start = time.time()
#cmd="grep 'ip\|name' hz/state.json"
#print(cmd)
#r = os.popen(cmd)

import lib.terra as terra
SSH = terra.SSH 

#data, data_name = terra.get_state(path="hz-min")
data, data_name = terra.get_state(path="hz")


def go(cmd,ip,name="<name>",mute=0):
    terra.ssh_exe(cmd,ip,name,mute)

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

