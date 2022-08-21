### Check enabled users 
```bash
sudo vi /etc/ssh/sshd_config  
# add the line
AllowUsers user1 user2

sudo service ssh restart

```

### Check enabled groups
```bash
AllowGroups my_ssh_enabled_group1  
```

get list of users belonging to this group  
```bash
getent group 2g-admin
```

The list of all users in the server machine can be found by running the below command on the server machine:

cat /etc/passwd


### Deny Root login
PermitRootLogin no

### Create SSH Key 
ssh-keygen -f ~/.ssh/my_key -t rsa -b 4096 -N ''  
This will create two files in your (hidden) ~/.ssh directory called: my_key and my_key.pub.  
The first: my_key is your `private key` and the other: my_key.pub is your `public key`.  

You have to copy the public key on the server and copy it to the authorized keys.  
cat my_key.pub >> ~/.ssh/authorized_keys   

rm id_rsa.pub   
And finally, set file permissions on the server:  

$ chmod 700 ~/.ssh  
$ chmod 600 ~/.ssh/authorized_keys  


### Disable password authentication forcing use of keys
PasswordAuthentication no


