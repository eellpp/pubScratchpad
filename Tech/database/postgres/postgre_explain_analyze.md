### Using Explain Analyze
You almost never talk about Postgres indexing without referring to the Explain feature. This is just one of those Postgres Swiss Army knife tools that you need to have in your pocket at all times. Explain analyze will give you information like query plan, execution time, and other useful info for any query. So as you’re working with indexes, you’ll be checking the indexes using explain analyze to review the query path and query time.   

You'll see that the query plan indicates a "Seq Scan," or a sequential scan. This means that it scans each data row in the table to see if it matches the query condition. You might be able to guess that for larger tables, a sequential scan could take up quite a bit of time so that’s where the index saves your database workload. 

### Understanding explain analyze output
https://www.cybertec-postgresql.com/en/how-to-interpret-postgresql-explain-analyze-output/
