https://bookdown.org/gubiithefish/test/101-Theory-061.html
The Clickstream fact table contains an entry for every record in the Web log.

Each entry has a number of key attributes that point to descriptive entries in the dimension tables. The measure attributes carry information about individual sessions (ID, total number of pages accessed during a session, total session time). Note that these attributes are not available in the log file. They have to be inferred during the data pre-processing phase, where the goal of the processing the data is to extract information into a structured format that supports the business perspective.

A common approach is to sort the log on IP and time, and then use a sequential scan to identify sequences of clicks that form a session (or clickstream journey).

https://mustafa-ileri.medium.com/how-to-store-your-clickstream-data-part-ii-be552088b14a
I used the date as partition and primary key. Because I need to get data for the last 30,60, 90 days. The disadvantage of this architecture is that: a new partition will be created for each day.

The most common partitioning in clickstream analytics is by time, using a year/month/day/hour/minutes structure. That’s the simplest and most manageable way to partition, because clickstream data is usually framed into time bounds as one of the first filters.

https://www.netguru.com/blog/clickstream-analytics-pipeline
At the end of the clickstream analytics data pipeline, normalization is required to minimize data redundancy and make sense of the data. The data must be prepared in the form of view on top of data tables, but before that happens, organized in a Raw Data Vault, where data is normalized into satellite, hubs, and links.


Clickstream data is extremely difficult to properly normalize in the data warehouse. That’s because it characterizes a huge number of dimensions, resulting in large tables with a large number of columns. Also, the clickstream isn’t reliable enough to consistently normalize the data with other data sources.

Product ID, revenue or basket size, and value aren’t necessarily accurate compared to the data source coming from backend systems where operations are confirmed for business and fully functional.

Therefore, don’t put too much effort into data normalization and treat the clickstream data source as its own entity with unique dimensions that don’t necessarily join with other parts of the business.

For a good balance, keep link tables and hubs only for what’s required for the business at that current point, instead of trying to normalize every single dimension. That way, the data is accessible earlier. However, that only works with modern columnar storage warehouses that can scale easily, and where filtering by columns improves performance significantly.

storage : 
http://www.eveandersson.com/arsdigita/asj/clickstream/
The data warehouse itself is a standard star schema, and consists of a single fact table and multiple dimensions. Note that the diagram below illustrating the star schema shows only a subset of the dimensions that we have in the data model.  
The granularity of the fact table is one page view. Each column of the fact table that references a particular dimension is a foreign key.  
The current data model includes the following dimensions:
- Page dimension: What was the name of the page requested? What type of page was requested? What was the url? What was the content type?
- Referrer dimension: What kind of referrer was it (e.g., search engine)? What was the referring url? What search text, if any, was used? If it was from inside the site, what is the referring page id?
- Date dimension: Which day of the week was the request? Day in the month? Day in the year? Which week in the year?
- User agent dimension: Which browser is the user using? Which version? Which operating system?
- Session dimension: When did a particular session start? When did it end? Which user? How many clicks were part of the session? What was the total value of the sales in the session?
- User state dimension: What is the current value of the shopping cart?
- User demographics dimension: What is the income level of the user? What is his/her race?
