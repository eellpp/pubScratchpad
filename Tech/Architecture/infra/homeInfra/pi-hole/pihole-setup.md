### How does Pi-hole block these ads?
1. open a Web browser   
2. type macworld.com into the address bar  
3. press Enter 
 Pi-hole looks up macworld.com and begins downloading it, but it will detect the domains used to serve advertisements and instead of looking up the real address of those sites, it will send a fake address instead. This allows the _legitimate_ content on macworld.com to load, but _prevents_ the ad images and videos from being downloaded. 
 
 This is a _critical_ difference between Pi-hole and traditional ad blockers because Pi-hole will prevent the ads from being downloaded in the first place (making the Webpage load faster) 
 
https://discourse.pi-hole.net/t/will-pi-hole-slow-down-my-network/2048  
 
4. watch the Webpage load on your screen - **your computer will still download macworld.com, but _not_ any domains that appear on the blocklist**  
5. watch the advertisements load as well - **since the ads were not downloaded in the first place, they do not need to be hidden from your view since they do not exist in the first place**  
6. Router Works as DNS server. Since ISP does not allow change of DNS server  


### Pi-hole is a DNS Sinkhole 
which means that it is used on your network as a DNS server, and will respond with a false address when any browser or other client software attempts to load content from a known advertiser. Pi-hole maintains a set of "blocklists" and in addition we've supplemented them with additional blocklists from WaLLy3K and firebog.net.  
DNS is the system used to resolve server hostnames such as balena.io into the IP address for the server sitting behind them when you try to load a web page, for example 52.210.75.180. In the case of an advertising server such as internetadvertising.com, Pi-hole will respond with a false address such as 0.0.0.0 rather than the real address, meaning that the advertising will not load.  



### Installation
Disable DHCP on Router  
Assign a fixed  IP with server with pihole installed on router  
pihole is installed on pi with rasbian  

URL:
http://192.168.0.72/admin


### Time based DHCP access
You can install a cron job that adds the corresponding domains (you can specify as many as you like in one call) at time X and removes them again at time Y


```bash
# m h  dom mon dow   command
# Block server.apple.com at 8AM
  0 8  *   *   *     pihole -b server.apple.com
# Unblock server.apple.com at 8PM
  0 20 *   *   *     pihole -b -d server.apple.com 
```

### UFW port requirements
https://docs.pi-hole.net/main/prerequisites/#ufw

```bash
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


### Regex Filtering

https://docs.pi-hole.net/regex/tutorial/

Testing Regex:  
https://docs.pi-hole.net/regex/testmode/   

pihole-FTL regex-test readm.org "(www\.)?readm.org"  

|Regex|Matches|
|---|---|
|manga|matches manga anywhere in domain|
|.*manga.com|matches anything before manga.com|
|.*\\.com\$|matches .com tld|

 ### Pihole Backup
 We need to backup pihole database. 
 - Stop pihole-FTL service
 - Take a copy of pihole-FTL.db  

What is pihole-FTL ?  
https://pi-hole.net/2018/02/22/coming-soon-ftldns-pi-holes-own-dns-dhcp-server/#page-content  
FTLDNS: Pi-hole’s Own DNS/DHCP server  
FTL is  "Faster than Light"  
`FTLDNS` is dnsmasq blended with Pi-hole’s special sauce. We bring the two pieces of software closer together while maintaining maximum compatibility with any updates Simon adds to dnsmasq.  
`dnsmasq` is free software providing Domain Name System (DNS) caching, a Dynamic Host Configuration Protocol (DHCP) server, router advertisement and network boot features, intended for small computer networks  

https://docs.pi-hole.net/database/

Uses SQLite3 for both for its long-term storage of query data and for its domain management 
- `Query database` /etc/pihole/pihole-FTL.db 
  -  We update this database periodically and on the exit of FTLDNS
  - The updating frequency can be controlled by the parameter DBINTERVAL and defaults to once per minute.   
  - maximum age for log queries to keep using the config parameter MAXDBDAYS. It defaults to 365 days
  - Taking backup while sqlite is running: `sqlite3 /etc/pihole/pihole-FTL.db ".backup /home/pi/pihole-FTL.db.backup"`

- `Domain database` /etc/pihole/gravity.db  

Teleporter allows you to import and export your Pi-hole settings.
```bash
https://docs.pi-hole.net/core/pihole-command/?h=tele#teleport
pihole -a -t
```
Create a configuration backup. The backup will be created in the directory from which the command is run. The backup can be imported using the Settings > Teleport page.  

The current (V5.0) version of Pi-hole does not export the custom list or /etc/pihole/pihole-FTL.conf. Take a backup of it manually. 



### Pi Hole High Availability Setup 
https://florianmuller.com/create-a-pihole-high-availability-setup-with-2-pihole-instances-on-proxmox-and-gravity-sync  
https://github.com/vmstan/gravity-sync  



