https://github.com/hetznercloud/cli  

Before you can start using the hcloud-cli you need to have a context available.  
in our hcloud-cli a context is a project in the Hetzner Cloud Console. 
```bash
hcloud context create my-super-project
```

This command will create a new context called my-super-project. After the command, you will be prompted to enter your API token. Keep in mind, the token is not visible while you are entering it. Press enter when you have entered the token. You should see a confirmation message Context my-super-project created and activated.

Now you should see an active context when you run
```bash
hcloud context list
```
hcloud context commands
```bash
Available Commands:
  active      Show active context
  create      Create a new context
  delete      Delete a context
  list        List contexts
  use         Use a context
```

Check server types and images with commands
```bash
hcloud server-type list  
hcloud image list 
```

create a server with command
```bash
hcloud server create --image ubuntu-18.04 --type cx11 --name my-cool-server  
```

delete server 
```bash
hcloud server delete my-cool-server
```

attach/detach volume to server
```bash
hcloud volume create --size 123 --name my-volume --server my-cool-server

hcloud volume detach my-volume
```


hcloud [command]
```bash
Available Commands:
  certificate        Manage certificates
  completion         Output shell completion code for the specified shell
  context            Manage contexts
  datacenter         Manage datacenters
  firewall           Manage Firewalls
  floating-ip        Manage Floating IPs
  help               Help about any command
  image              Manage images
  iso                Manage ISOs
  load-balancer      Manage Load Balancers
  load-balancer-type Manage Load Balancer types
  location           Manage locations
  network            Manage networks
  placement-group    Manage Placement Groups
  server             Manage servers
  server-type        Manage server types
  ssh-key            Manage SSH keys
  version            Print version information
  volume             Manage Volumes
 ```
 
 hcloud server  
 ```bash
 Available Commands:
  add-label                   Add a label to a server
  add-to-placement-group      Add a server to a placement group
  attach-iso                  Attach an ISO to a server
  attach-to-network           Attach a server to a network
  change-alias-ips            Change a server's alias IPs in a network
  change-type                 Change type of a server
  create                      Create a server
  create-image                Create an image from a server
  delete                      Delete a server
  describe                    Describe a server
  detach-from-network         Detach a server from a network
  detach-iso                  Detach an ISO from a server
  disable-backup              Disable backup for a server
  disable-protection          Disable resource protection for a server
  disable-rescue              Disable rescue for a server
  enable-backup               Enable backup for a server
  enable-protection           Enable resource protection for a server
  enable-rescue               Enable rescue for a server
  ip                          Print a server's IP address
  list                        List servers
  metrics                     [ALPHA] Metrics from a Server
  poweroff                    Poweroff a server
  poweron                     Poweron a server
  reboot                      Reboot a server
  rebuild                     Rebuild a server
  remove-from-placement-group Removes a server from a placement group
  remove-label                Remove a label from a server
  request-console             Request a WebSocket VNC console for a server
  reset                       Reset a server
  reset-password              Reset the root password of a server
  set-rdns                    Change reverse DNS of a Server
  shutdown                    Shutdown a server
  ssh                         Spawn an SSH connection for the server
  update                      Update a Server
 ```
