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

 


### Disable password authentication forcing use of keys
PasswordAuthentication no


