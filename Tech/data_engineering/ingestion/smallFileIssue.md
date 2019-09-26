Hadoop Small files

1) Each file has entry in namenode. More the number of of files, the namespace is taken over. In namenode, the metadata for the files is kept in memory. So you could run out of memory. 
In general, the namenode server should have high memory.

2) More the number of files, smaller would be unit of parallel work on each file and during shuffling there would be lot of IO for creating temp files. Generally large files in order of 128MB is preferred. Especially compressed. So that each file could contain large amount of rows of data. This makes the problem CPU bound, as the container would operate on single file. Large number of small files makes the problem IO bound when shuffling is involved.
