
By default, UFW will block all of the incoming connections and allow all outbound connections. This means that anyone trying to access your server will not be able to connect unless you specifically open the port, while all applications and services running on your server will be able to access the outside world.  

https://linuxize.com/post/how-to-setup-a-firewall-with-ufw-on-ubuntu-18-04/


sudo ufw status numbered

### Delete rule by number
sudo ufw delete <number>

### Allow only tcp protocol from 192.168.0.1 to 192.168.0.255 to the port 32400 
sudo ufw allow from 192.168.0.1/24 proto tcp to any port 32400

https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands

To allow incoming connections from a specific IP address or subnet, you’ll include a from directive to define the source of the connection. This will require that you also specify the destination address with a to parameter. To lock this rule to SSH only, you’ll limit the proto (protocol) to tcp and then use the port parameter and set it to 22, SSH’s default port.

The following command will allow only SSH connections coming from the IP address 203.0.113.103:  

Check in local DHCP server the local ip address range and permission to only that range 

sudo ufw allow from 192.168.0.1/24 proto tcp to any port 32400

  
### UFW port requirements
for server with 
  - pihole 
  - plex

```bash
32400                      ALLOW       192.168.0.0/24
80                         ALLOW       192.168.0.0/24            
443                        ALLOW       192.168.0.0/24            
22/tcp                     ALLOW       192.168.0.0/24            
67/tcp                     ALLOW       Anywhere                  
67/udp                     ALLOW       Anywhere                  
53/tcp                     ALLOW       192.168.0.0/24            
53/udp                     ALLOW       192.168.0.0/24            
67/tcp (v6)                ALLOW       Anywhere (v6)             
67/udp (v6)                ALLOW       Anywhere (v6) 
```

|port|Desc|
|---|---|
|53|DNS server|
|67|DHCP server for Ip Address assignment|
|80|Webserver|
|443|SSl port web server|
