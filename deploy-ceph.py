#!/usr/bin/python3

# 2022 GPL v2 only  
# - flo932@uxsrv.de micha.r

import time

START = time.time()

import os
import time

NODE="abc"
NODE="node"
IP="10.0.1."

SUB="ceph"

os.chdir(SUB)

import lib.terra as terra
SSH = terra.SSH

data, data_name = terra.get_state()

def go(cmd,ip,name="<name>",mute=0):
    terra.ssh_exe(cmd,ip,name,mute)


import uuid
fsid=str(uuid.uuid4())
print("fsid:",fsid)

nodes=""
ips=""
f =1 
for j in range(len(data)):
    if f == 0:
        nodes+=","
        ips+=","
    nodes += NODE+str(j)
    ips += IP+str(5+j)
    f=0

# clean and config
for i in range(len(data)):
    name = data_name[i]
    ip = data[i]
    print([name,ip])

    
    cmd=SSH + ' -- \'rm -rf /root/'+SUB+'/*\''
    go(cmd,ip,name)
    cmd=SSH + ' -- \'mkdir -p /root/'+SUB+'/\''
    go(cmd,ip,name)

    txt = "##################\n"
    txt+="fsid={}".format(fsid)
    txt+="\n"
    txt+="host={}".format(name)
    txt+="\n"
    txt+='node={}'.format(NODE+str(i))
    txt+="\n"
    txt+="ip={}".format(IP+str(5+i))
    txt+="\n"
    txt+="pubnet={}".format(IP+"0/24")
    txt+="\n"
    txt+="\n"

    txt+="eip={}".format(ip)
    txt+="\n"
    txt+="eips='" + ",".join(data) +"'"
    txt+="\n"
    txt+="hosts='" + ",".join(data_name) +"'"
    txt+="\n"
    txt+="\n"

    txt+="nodes='"+nodes+"'"
    txt+="\n"
    txt+="ips='"+ips+"'"
    txt+="\n"
    txt+="\n"
    print(txt)
    

    os.system("mkdir -p ./log/")
    fn = "./log/host-{}.conf".format(name)
    f = open(fn,"w")
    f.write(txt)
    f.close()

    #sys.exit()
    cmd='dd if=./log/host-{}.conf | '.format(name) + SSH + ' -- \'dd of=./'+SUB+'/host.conf\''.format(f)
    go(cmd,ip,name)

    cmd=SSH+' -- \'ls \''
    go(cmd,ip,name)

# cp sh's
for i in range(len(data)):
    name = data_name[i]
    ip = data[i]
    print([name,ip])
    for f in os.listdir("."):
        if ".sh" in f and "run-" in f:
            print(f)
            cmd='dd if={} status=none | '.format(f) + SSH + ' -- \'dd of=./'+SUB+'/{}\' status=none '.format(f)
            go(cmd,ip,name)

# run apt
for i in range(len(data)):
    name = data_name[i]
    ip = data[i]
    print([name,ip])

    #cmd=SSH+' -- \'sh /root/'+SUB+'/run-kill.sh \''
    #go(cmd,ip,name)

    #cmd=SSH+' -- \'sh /root/'+SUB+'/run-apt.sh \''
    #go(cmd,ip,name)



print( "# run initial setup and extraction on primary-node")
for i in range(len(data)):
    name = data_name[i]
    ip = data[i]
    print([name,ip])

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-setup-first.sh \''
    go(cmd,ip,name)
    #cmd=SSH+' -- \'sh /root/'+SUB+'/run-setup-dash.sh \''
    #go(cmd,ip,name)

    # exctract conf
    cmd=SSH+' -- \'sh /root/'+SUB+'/run-get.sh -- > '+SUB+'/get-{}.log\''.format(name)
    go(cmd,ip,name)

    cmd=SSH+' -- \'cat '+SUB+'/get-{}.log\' > log/get-{}.log'.format(name,name)
    go(cmd,ip,name)
    break # only on first host

print("---------------------------------------")
print("---------------------------------------")
print("---------------------------------------")


# run injection
first = 1
src = "xxxx"
for i in range(len(data)):
    name = data_name[i]
    ip = data[i]
    print([name,ip])

    #cmd=SSH+' -- \'sh /root/'+SUB+'/run-conf.sh \''
    #go(cmd,ip,name)

    if first:
        src = name
        first = 0
        # not on first host
        continue

    # copy primary config and key's -> :to second nodes as set.sh
    cmd='dd if=./log/get-{}.log | '.format(src) + SSH + ' -- \'dd of=./'+SUB+'/set.sh\''
    go(cmd,ip,name)

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-setup-sec.sh \''
    go(cmd,ip,name)


# run injection
for i in range(len(data)):
    name = data_name[i]
    ip = data[i]
    print([name,ip])

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-setup-fin.sh \''
    go(cmd,ip,name)

time.sleep(1)
# run injection
for i in range(len(data)):
    name = data_name[i]
    ip = data[i]
    print([name,ip])

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-ps.sh \''
    go(cmd,ip,name)

print("duration:" , round(time.time()-START,2),"sec")
