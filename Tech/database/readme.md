

### Sqlite when to use

https://www.sqlite.org/whentouse.html

- Only one writer. Sqlite locks the whole database when writing. (generally for few milliseconds)
- Supports unlimited amount of concurrent readers
- Max joins of 64 tables
- no maximum number of tables per database
- Max string/blob size is by default 2.15 GB .If more than that then split the file by rows. THis is adjustanble
- Max columns is 2000. This is adjustable to upto 32767 
- Max database size is 281 terabyte. A 281 TB database where each row has very little data (no indices) has around 2 trillion rows. For rows with some data, first the max database size limit will be breached 
- Maximum number of pages in database file is 2Billion 

Note that with a web framework that can do async IO, a single thread can still realistically serve 20–100 requests per second without special configuration when the requests are IO-bound. That's not “web-scale”, but it's good enough for small and medium sites. For a database that has rare updates (e.g. blog posts, user accounts), the limitation of one writing process is not a bottleneck.

> I ran a niche community social bookmarking site (around 100-200k pageviews per month) on SQLite for several years and it was no problem at all. If a write was occurring, having a simultaneous request wait 100 milliseconds was no big deal. It only became a problem when I got tired of ops and wanted to put it on Heroku at which time I had to migrate to Postgres.

> It's not even the _percentage_ of reads vs writes; it's about the _total time spent writing_. Suppose that while a single user was actively using the website, the time spent writing was 70%. That's a totally mad write load; but even then, if you had two concurrent users, things would probably still be quite useable -- you'd have to go up to 4 or 5 users before things really started to slow down noticeably.
  Suppose, on the other hand, that a single user generated around a 1% write utilization when they were actively using the website (which still seems pretty high to me). You could probably go up to 120 concurrent users quite easily. And given that not all of your users are going to be online at exactly the same time, you could probably handle 500 or 1000 _total_ users.

> But if you have a write transaction every second, but each transaction only takes 1ms, that's still ~1000 concurrent users before you start to get noticeable lag of few sec for reads

> I write applications with in Go using a SQLite backend and it's not uncommon to see writes transactions that are in the 100s of microseconds. I typically see read transactions with multiple queries around ~50µs. That's all running on very modest $5/month DigitalOcean droplets. The vast majority of web applications do not see thousands of requests per second so I think SQLite is a great fit for most web apps.

Bottlneck:
- one slow write transaction can cause the website to slow down. As long as writes are fast, there would be no issues

SQLite works great as the database engine for most low to medium traffic websites (which is to say, most websites). The amount of web traffic that SQLite can handle depends on how heavily the website uses its database. Generally speaking, any site that gets fewer than 100K hits/day should work fine with SQLite. The 100K hits/day figure is a conservative estimate, not a hard upper bound. SQLite has been demonstrated to work with 10 times that amount of traffic.

The SQLite website ([https://www.sqlite.org/](https://www.sqlite.org/)) uses SQLite itself, of course, and as of this writing (2015) it handles about 400K to 500K HTTP requests per day, about 15-20% of which are dynamic pages touching the database. Dynamic content uses [about 200 SQL statements per webpage](https://www.sqlite.org/np1queryprob.html). This setup runs on a single VM that shares a physical server with 23 others and yet still keeps the load average below 0.1 most of the time.



----

There are no solutions, only tradeoffs.    

### Database Normalization 
https://news.ycombinator.com/item?id=32407873.  
Prof: "Why do we normalize?"    
Class, in unison: "To make better relations."    
Prof: "Why do we denormalize?"   
Class, in unison: "Performance."   
It took a lot of years of work before the simplicity of the lesson stuck with me. Normalization is good. Performance is good. You trade them off as needed. Reddit wants performance, so they have no strong relations. Your application may not need that, so don't prematurely optimize.   

----
Foreign Key constraints have performance cost    
The database needs to guarantee that the referred record actually exists at the time the transaction commits. Postgres takes a lock on all referenced foreign keys when inserting/updating rows, this is definitely not completely free.
Found this out when a plain insert statement caused a transaction deadlock under production load.  

