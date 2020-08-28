Hash tables provide constant time O(1) access for single values, while trees provide logarithmic time O(log n) access.  
Then why databases use btree while programming code use hash maps.  

- good hashing function:  To avoid hash collision. Upon hash collision, hashmap will take O(n) time to find the right result. For btree the worst is O(logn)
- ordered query: Trees keep values in order. We can find all values that start with a given prefix, or the "top k" values easily in btree, while with a hash table the first value will be O(1) but for others we still need to scan entire table again. 
- adding multiple index in btree is easy without copying the entire data. It reuses the existing indexes. For large datasets this becomes problem for hash table.  

https://www.evanjones.ca/ordered-vs-unordered-indexes.html  

