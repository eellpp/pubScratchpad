**What are the various datetime types in hive?**
- Date 
- TIME 
- TIMESTAMP (java.sql.Timestamp) 

**What is the data type of unix timestamp ?**
Unix timestamp is integer type if in sec
If its in millisec then its bigint type
the timezone is always UTC

**How to get the current default timezone in hive ?**
date_format(current_timestamp(),"z")

**How to convert a timstamps in sec to string format ?**
> from_unixtime(bigint timestamp, format)

This converts from unix timestamp to local default server timezone hive timestamp  
eg format : 'MM-dd-yyyy HH:mm:ss' 
The time shown is converted to server timezone by hive on query


**How to convert integer timestamp to another timezone datetime?**
Using three function:
- from_unixtime : to get the local server time from unix time . Returns a string
- to_utc_timestamp: to convert from server time  zone to hive timestamp type in UTC . Returns hive timestamp in UTC zone
- from_utc_timestamp: to convert  from hive timestamp type in UTC zone, to output time zone

eg: converting from timestamp to SGT, when running on server with default timezone as EST
> from_utc_timestamp(to_utc_timestamp(from_unixtime(integer_ts),"EST"),"SGT")
- first gets the hive timestamp into server timezone
- converts from server timzone to utc
- from utc converts to sgt

**Hive timestamp datatype**
When you ingest data into column into hive, internally it is saved as offset to epoch.  
However viewing data from timestamp field creates wierd results  

The ingested data: "2023-05-12 14:45:34".  
If this string is in UTC, then to get the unix_timestamp() correct value. 
First change the spark session to UTC    
>>> spark.conf.set('spark.sql.session.timeZone', 'UTC' ).   
now unix_timestamp("<utc time string>") will give correct value. 





