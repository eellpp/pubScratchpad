### Scaling 
If you're using some python/ruby/JS thing you're probably going to need some kind of reverse proxy to keep up with top of HN. If you're using a Haskell/Rust/C++/etc. compiled backend you're probably fine.

### Hetzner
- I handle ~150TB and 26M page views for ~$500 by simply renting a few dedicated servers at hetzner. And if I didn't need quite a lot of processing power (more than average website), it would be much lower. I only need so many servers for the CPU power, not traffic.
- Hetzner root servers, there is nothing else I know on the market that comes close in price/power ratio when you use the "Serverbörse". I run multiple low traffic websites, databases and a heavy traffic elk instance + my complete homelab in proxmox / docker for 48€ a month and there is even room for more. Highly recommended!
- Serverbörse" machines are very non-uniform, which may be bad for load balancing. See yourself: https://www.hetzner.com/sb
- I have 3 servers, 2/3 don't have hardware timestamping on the interface, 1 does. Makes a huge difference when it comes to NTP.

All dedicated root servers have unlimited traffic.
- 1GBit/s line (88 Euro)
- If max total size of requests are say 1 MB (8Mbit). Then it can handle 128 qps 

Hetzner SB servers start at 28 EUR and they _do_ come with unlimited bandwidth and 2 x 3TB disks. For 30 EUR you can get a E3-1245 with 2x4TB disk.  

A single commodity server should easily give 2GB/s(16gbps) to public internet  
- Dell R340 with a dual-10G NIC and some SSDs. That's not commodity, that's cheap, a commodity server would be a dual-Xeon but that's overkill for serving 16gbps.  
- At Netflix we’re doing close to 400Gbps on 1U commodity hardware, and pretty inexpensive.  

### Cloudfare
Cloudflare's free tier is more than enough for basic CDN serving and DDOS protection.
$20/month for Cloudflare Pro is good deal for scaling  
- Cloudflare's TOS prohibits you from using their CDN to serve "video or a disproportionate percentage of pictures, audio files, or other non-HTML content" on typical plans.  

Cloudfront's bandwidth pricing is outrageously high at $0.08/GB (up to $0.12/GB for some regions). Meanwhile, Cloudflare doesn't even charge for bandwidth.

### High Traffic website with dynamic parts
For such traffic heavy websites I don’t think there’s a better combination than Static Websites hosted over CDN, which is cached aggressively and for the dynamic part serverless as a backend. If you configure it properly (cache optimization, rate limiting to not get a huge paycheck if DDoSed, etc…) this setup is like set-up-and-forget-it, without the need to invest loads of resources into it.  

- I have a lightweight theme with minimal dynamic content, and I use LiteSpeed cache on the server. That's it. Easily handled 20-40 thousand pageviews over a couple of hours (around 5 - 10 qps). (Was on HN front page)

database queries:  
MySQL (and PostgreSQL, for that matter) isn't bad at handling queries, when the tables are tuned for those queries. People don't do this well (if at all), and few databases are capable of automatically tuning tables (creating indices), since they require resources, and can have tradeoffs between read and write performance.  
Properly tuned, a database is able to handle millions of requests per second.  

Raspberry PI  
- With plain Nginx serving a static HTML file, I could hit 1000 requests per second.
- was able to get 20-90 requests per second served from a Raspberry Pi 2 running a PHP website with a PostgreSQL database, depending on the complexity of the page
- TLS request will slow down rpi  
- home dsl uplink generally have low bandwidth and high latency. 


### Static Website
github pages   
GitHub Pages is a static site hosting service that takes HTML, CSS, and JavaScript files straight from a repository on GitHub, optionally runs the files through a build process, and publishes a website. 
- source repositories have a recommended limit of 1GB. 
- soft bandwidth limit of 100GB per month.



### Firbase
Many use Firebase for auth and user management only  

### Server Bandwidth cost
cloud servers have high bandwidth cost. 

- $5/mo Digital Ocean VPS Wordpress site hit the top of HN before. I kept an eye on htop, but it handled it just fine
- I had a blog post on the frontpage of hn for more tht 20 hours and my cheap Vps for 3€ a month could handle it perfectly since my website is just a statically generated website with hugo.

- The backend for my app currently handles 500 qps for 300$ in GCP.
- I was running www.Photopea.com with 10M page views a month for $40 a year. Now, I upgraded to $60 a month. I never used any CDN.


### Serving TB of data
At 80TB (~83886080 MB) and 5 Million request per month, that's 16,77 MB per request in average. And at 1.92 qps (request per sec) that's 32,2 MB per second.
So they're saturating 25% of a gigabit uplink every second of the month.

### Calculating latency
Ping time new york <-> tokoyo is about 180ms. So lets say as a worse case the ping time to the single server is 180ms (its probably not that bad), and lets say the latency to cloudflare edge server is 20ms.  

So using cloudflare on a cache hit (best case), you save something like 160ms per roundtrip per packet.

If you're doing a cold start, you'll pay that latency cost several times over: 
- first the TCP handshake (3 roundtrips), and then the TLS handshake (2 more roundtrips). 
- That's 800ms of extra latency before you even get to sending the first HTTPx request.

Having edge server and cache hits saves this latency  

### Concurrant Users Load testing
https://loader.io/pricing  
