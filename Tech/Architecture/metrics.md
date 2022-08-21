### Events per sec per server
problems: First, you need a single ordinary server (like EC2) to be able to ingest, transform, and store about 10M events per second continuously, while making that data fully online for basic queries. You can’t afford the latency overhead and systems cost of these being separate systems. You need this efficiency because the raw source may be 1B events per second; even at that rate, you’ll need a fantastic cluster architecture.  

Most of the open source platforms tap out at 100k events per second per server   

VictoriaMetrics ingest rates are around 300k / per second / PER CORE. So theoretically you should be fine with just a single n1-standard-32 or *.8xlarge node.   

https://news.ycombinator.com/item?id=24814687

