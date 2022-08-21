### netstat to find open ports
netstat shows the open ports and established connections.
```bash
netstat -anp 

# Where:
#-a: shows the state for sockets.
#-n: shows IP addresses instead of hots.
#-p: shows the program establishing the conenction.
```

### UFW  firewall
sudo ufw status verbose  
sudo ufw enable  
sudo ufw default deny incoming # by default block incoming  
ufw allow <port>  
sudo ufw allow from 192.168.1.1 to any port 22 proto tcp  

 

### iftop to monitor your network traffic
Check available interfaces:  
  - ifconfig -a  
  - netstat -i   
  
sudo iftop  <interface>  

### lsof to check files opened by processes 
Report a list of all open files and the processes that opened them.

### Who to check logged in users
who  
  
### Dig to check dns server
The dig command in Linux is used to gather DNS information. It stands for Domain Information Groper, and it collects data about Domain Name Servers. The dig command is helpful for diagnosing DNS problems, but is also used to display DNS information.

dig <hostname>
  
### nslookup
Nslookup (stands for “Name Server Lookup”) is a useful command for getting information from DNS server. It is a network administration tool for querying the Domain Name System (DNS) to obtain domain name or IP address mapping or any other specific DNS record. It is also used to troubleshoot DNS related problems  
  
  
