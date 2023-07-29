import time
import os

START = time.time()



import time
import os

START = time.time()

#os.system("rm ssh-key*") # re generate ssh-key for vm's
if not os.path.isfile("ssh-key"):
    cmd='ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ssh-key -q -N ""'
    os.system(cmd)




cmd="cd ../hz-min; terraform state pull > state.json"
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


print()
print("cleanup local ssh-keys")
import sys
for line in data:
    print(line)

    ip = line
    print(sys.argv)

    cmd='ssh-keygen -f "/home/micha/.ssh/known_hosts" -R "{}"'.format(ip)
    os.system(cmd)



# ----- destroy cloud

os.system("rm -v ssh-key*") # re generate ssh-key for vm's
if not os.path.isfile("ssh-key"):
    cmd='ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ssh-key -q -N ""'
    os.system(cmd)

cmd="terraform apply -auto-approve -destroy "
print(cmd)
os.system(cmd)

os.system("rm -v ssh-key*") # re generate ssh-key for vm's

print("duration:" , round(time.time()-START,2))
