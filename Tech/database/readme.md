



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

