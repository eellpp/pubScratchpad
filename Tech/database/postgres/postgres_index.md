https://blog.crunchydata.com/blog/postgres-indexes-for-newbies  

Indexes are their own data structures and they’re part of the Postgres data definition language (the DDL). They're stored on disk along with data tables and other objects. 

1) B-tree indexes are the most common type of index and would be the default if you create an index and don’t specify the type. B-tree indexes are great for general purpose indexing on information you frequently query. 
2) BRIN indexes are block range indexes, specially targeted at very large datasets where the data you’re searching is in blocks, like timestamps and date ranges. They are known to be very performant and space efficient.
3) GIST indexes build a search tree inside your database and are most often used for spatial databases and full-text search use cases. 
4) GIN indexes are useful when you have multiple values in a single column which is very common when you’re storing array or json dat

https://use-the-index-luke.com/  

