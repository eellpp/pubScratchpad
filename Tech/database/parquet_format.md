Each parquet file contains both data and metadata 

Parquet files are composed of row groups, header and footer. Each row group contains data from same columns

This allows for columnar access. Eg fetching 5 columns in a 50 column table will involving reading only from those row groups

Parquet file allows addition of more columns. Schema evolution

Parquet is a binary format and allows encoded data types like boolean, numberci and byte array
