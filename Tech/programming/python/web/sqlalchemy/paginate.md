## Postgres

### Offset Pagination
When retrieving data with offset pagination, you would typically allow clients to supply two additional parameters in their query: an offset, and a limit.
An offset is simply the number of records you wish to skip before selecting records. This gets slower as the number of records increases because the database still has to read up to the offset number of rows to know where it should start selecting data. This is often described as O(n) complexity, meaning it's generally the worst-case scenario. Additionally, in datasets that change frequently as is typical of large databses with frequent writes, the window of results will often be inaccurate across different pages in that you will either miss results entirely or see duplicates because results have now been added to the previous page.  

SQLAlchemy’s  slice(1, 3) . It generates SQL ending in LIMIT 1 OFFSET 3.   

Issues:  
- `result inconsistency` : traversing a resultset should retrieve every item exactly once, without omissions or duplication .(Add/Delete of data during operation)   
- `offset inefficiency`: delay incurred by shifting the results by a large offset. Large offsets are intrinsically expensive. Even in the presence of an index the database must scan through storage, counting rows.   

When to Use: Limit-offset  
Applications with restricted pagination depth and tolerant of result inconsistencies.  

### Keyset pagination  
The Keyset Pagination allows you to use an index to locate the first record of any page that needs to be navigated, and, for this reason, the SQL query can scan fewer records than when using the default OFFSET pagination  

- Create an index column  
- SELECT * FROM table WHERE indexed_column > current_offset ORDER BY n ASC LIMIT 5;


### Cursor 


https://www.citusdata.com/blog/2016/03/30/five-ways-to-paginate/
