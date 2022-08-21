### Load Balancer:  
https://www.hetzner.com/cloud/load-balancer

### Private Network on Hetzner cloud:  
Networks is a free feature for the Hetzner Cloud, which allows you to create private IPv4 networks between your Hetzner Cloud servers. For example, you could create a database server which is only available on the private network instead of binding it to the public network, where it would be accessible from everywhere.  

https://community.hetzner.com/tutorials/hcloud-networks-basic

Networks provide private layer 3 links between Hetzner Cloud Servers using dedicated network interfaces.  
Whenever you attach a server to a network, our system will automatically assign an IPv4 address within your private network to it  

IP Address are in range:  
- 10.0.0.0/8  
- 172.16.0.0/12  
- 192.168.0.0/16  

What are Subnets?  
Subnets are a part of the networks feature. When you create a network, you need to define its IP range. Within this IP range, you can create one or more subnets that each have its own IP space within the network IP range. IPs for your servers will always be allocated from your subnet IP space.  

Example: You create a network 10.0.0.0/8. Within the network you create a subnet 10.0.0.0/24. When you attach a server to your network, it will get an IP from the 10.0.0.0/24 subnet.

- You can attach up to 100 servers to a network.
- Every server can have up to 5 alias IPs in addition to its private main IP.
- You can create up to 50 subnets.
- You can create up to 100 routes.

```bash
hcloud server create --name node-1 --type cx11 --image ubuntu-18.04
hcloud server create --name node-2 --type cx11 --image ubuntu-18.04

hcloud network create --name my-network --ip-range 10.0.0.0/8
hcloud network add-subnet my-network --network-zone eu-central --type server --ip-range 10.0.0.0/24  

hcloud server attach-to-network node-1 --network my-network
hcloud server attach-to-network node-2 --network my-network --ip 10.0.0.7  

# Check assigned ip address
hcloud server describe node-1 
hcloud server describe node-2 

hcloud server ssh node-1 

hcloud server delete node-1
hcloud server delete node-2

hcloud network 
```

https://community.hetzner.com/tutorials/hcloud-networks-basic

