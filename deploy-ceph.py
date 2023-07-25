#!/usr/bin/python3

# 2022 GPL v2 only  
# - micha@uxsrv.de M.Rathfelder

import time

START = time.time()

import os
import time

NODE="abc"
NODE="node"
IP="10.0.1."

SUB="ceph"

os.chdir(SUB)

cmd="cd ../hz; terraform state pull > ../hz/state.json"
print(cmd)
r = os.system(cmd)
print(r)

start = time.time()
cmd="grep 'ip\|name' ../hz/state.json"
print(cmd)
r = os.popen(cmd)



SSH = 'ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i "../hz/ssh-key"  root@{} '
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
            cmd='dd if={} | '.format(f) + SSH + ' -- \'dd of=./'+SUB+'/{}\''.format(f)
            go(cmd,ip,name)

# run apt
for i in range(len(data)):
    name = data_name[i]
    ip = data[i]
    print([name,ip])

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-apt.sh \''
    go(cmd,ip,name)

print( "# run initial setup and extraction on primary-node")
for i in range(len(data)):
    name = data_name[i]
    ip = data[i]
    print([name,ip])

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-conf-single.sh \''
    go(cmd,ip,name)

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-setup-key.sh \''
    go(cmd,ip,name)

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-setup-mon.sh \''
    go(cmd,ip,name)

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

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-conf.sh \''
    go(cmd,ip,name)

    if first:
        src = name
        first = 0
        # not on first host
        continue


    # copy primary config and key's -> :to second nodes as set.sh
    cmd='dd if=./log/get-{}.log | '.format(src) + SSH + ' -- \'dd of=./'+SUB+'/set.sh\''
    go(cmd,ip,name)
    cmd=SSH + ' -- \'sh /root/'+SUB+'/set.sh\''
    go(cmd,ip,name)

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-setup-mon.sh \''
    go(cmd,ip,name)

    cmd=SSH+' -- \'sh /root/'+SUB+'/run-setup-osd.sh \''
    go(cmd,ip,name)



print("duration:" , round(time.time()-START,2),"sec")
