import time
import os

START = time.time()


os.system("rm -v ssh-key*") # re generate ssh-key for vm's
if not os.path.isfile("ssh-key"):
    cmd='ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ssh-key -q -N ""'
    os.system(cmd)

cmd="terraform apply -auto-approve -destroy "
print(cmd)
os.system(cmd)

os.system("rm -v ssh-key*") # re generate ssh-key for vm's

print("duration:" , round(time.time()-START,2))
