

### Visa 4000 TPS (Year 2017)
VISA handles on average around 2,000 transactions per second (tps), so call it a daily peak rate of 4,000 tps. It has a peak capacity of around 56,000 transactions per second, [1] however they never actually use more than about a third of this even during peak shopping periods. [2]

PayPal, in contrast, handled around 10 million transactions per day for an average of 115 tps in late 2014. [3]
Let's take 4,000 tps as starting goal. Obviously if we want Bitcoin to scale to all economic transactions worldwide, including cash, it'd be a lot higher than that, perhaps more in the region of a few hundred thousand tps. And the need to be able to withstand DoS attacks (which VISA does not have to deal with) implies we would want to scale far beyond the standard peak rates. Still, picking a target let us do some basic calculations even if it's a little arbitrary.
Today the Bitcoin network is restricted to a sustained rate of 7 tps due to the bitcoin protocol restricting block sizes to 1MB.

### Alibaba 256K TPS - 2017 Singles Day
Shoppers from at least 192 countries and regions swarmed the e-commerce giant to scoop up discounted lobster, iPhones and refrigerators, at a rate of as many as 256,000 transactions per second. 

### Best DB performance is 1 million queries per sec on 20 core CPU - 2017
The best performance for traditional databases that I could find on the Internet was around one million queries per second. It was MariaDB running on a 20-core machine. See details here. So, it is 50K requests per second. One of the best databases on the market, tuned by probably the best database people on earth can only provide 50K requests per second on a single CPU core.


### Bitcoin 7 TPS - 2017
A theoretical maximum speed for Bitcoin that has been circulating online is seven transactions per second.


https://dzone.com/articles/asynchronous-processing-with-in-memory-databases-o

### Doing all the application and database logic in single application
You just surrounded a data structure with a server in order to grant other applications remote access to this data structure and got a 40x performance penalty! This is so sad that I think that we should forget about multitier architecture and write all the business logic and database logic in a single application inside a single process. Or... we can try to optimize the database server.
Let's look closer at what's happening when a database server with the above-mentioned architecture processes a transaction in terms of system calls.
-  Read a request from the network.
-  Lock the hash.
-  Unlock the hash.
-  Write to the transaction log.
-  Write to the network.
These are at least five syscalls to a database per request. Each syscall requires entering the kernel mode and exiting the kernel mode.
On entering/exiting the kernel mode, there is a context switching. Context switching implies tons of extra work — you need to back up and to restore all the registers and other sensitive information. See details here.
https://dzone.com/articles/asynchronous-processing-with-in-memory-databases-o


### In memory hash table operations per sec
What we see now is that an in-memory hash table is able to perform two million operations per second on a single CPU core. 

### HBase, Cassandra performance - 32 core
https://www.datastax.com/wp-content/themes/datastax-2014-08/files/NoSQL_Benchmarks_EndPoint.pdf
Cassandra achieving 300k read/writes per sec . Highest among all
