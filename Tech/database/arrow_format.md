
### Arrow vs Parquet
 Parquet is a _file_ format, Arrow is a language-independent _in-memory_ format. You can e.g. read a parquet file into a typed Arrow buffer backed by shared memory, allowing code written in Java, Python, or C++ (and many more!) to read from it in a performant way (i.e. without copies).
 
 Arrow is a language-independent memory layout. It’s designed so that you could stream memory from (for example) a Rust data source to a spark/DataFusion/Python/whatever else/etc with faster throughout and support for zero-copy reads, and no serialisation/deserialisation overhead. Having the same memory model ensures better type and layout consistency as well, and means that query engines can get on with optimising and running queries rather than also having to worry about IO optimisations as well.
 
 
