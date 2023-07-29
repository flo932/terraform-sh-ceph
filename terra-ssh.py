#!/usr/bin/python3

import os
import time


import lib.terra as terra
SSH = terra.SSH 

data, data_name = terra.get_state()


def go(cmd,ip,name="<name>",mute=0):
    terra.ssh_exe(cmd,ip,name,mute)
print(data)
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

