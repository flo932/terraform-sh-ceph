import time
import os

START = time.time()

#os.system("rm ssh-key*") # re generate ssh-key for vm's
if not os.path.isfile("ssh-key"):
    os.system("rm ssh-key")
    os.system("rm ssh-key.pub")

    cmd='ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ssh-key -q -N ""'
    os.system(cmd)



cmd="terraform apply -auto-approve "
print(cmd)
os.system(cmd)

# reinit ssh
import os
import time

cmd="cd hz; terraform state pull > state.json"
cmd=" terraform state pull > state.json"
print(cmd)
os.system(cmd)

start = time.time()
cmd="grep 'ip\|name' hz/state.json"
cmd="grep 'ip\|name' state.json"
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
SSH = ' ssh -o StrictHostKeyChecking=no -o "IdentitiesOnly=yes" -i ./ssh-key  root@{} '
def go(cmd,ip,name="<name>",mute=0):
    cmd=cmd.format(ip)
    if mute == 0:
        print(cmd)
    #print(cmd)
    r=os.popen(cmd)
    if mute == 0:
        print("--",r)
        for line in r:
            print(line.strip())


print()
for line in data:

    ip = line
    #print(sys.argv)

    print()
    print("delete from known_host")
    cmd='ssh-keygen -f "/home/micha/.ssh/known_hosts" -R "{}"'
    go(cmd,ip,mute=0)

print("sleep 10s")
time.sleep(10)


for line in data:
    ip = line
    #print(sys.argv)

    print()
    print("test new host")
    cmd=SSH + ' -- echo "$(hostname) OK !" '
    go(cmd,ip,mute=0)






time.sleep(.5)
print()
print("duration:" , round(time.time()-START,2)  ,"sec")
