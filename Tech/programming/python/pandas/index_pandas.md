Different types of indexes

https://pandas.pydata.org/pandas-docs/version/1.0.1/reference/indexing.html  

- `Numeric Index`: RangeIndex, Int64Index, UInt64Index, Float64Index  
- `CategoricalIndex` :Index based on an underlying Categorical  
- `IntervalIndex`: Immutable index of intervals that are closed on the same side  
- `MultiIndex`: A multi-level, or hierarchical, index object for pandas objects. 
- `DatetimeIndex`: Immutable ndarray of datetime64 data, represented internally as int64, and which can be boxed to Timestamp objects that are subclasses of datetime and carry metadata such as frequency information.  
- `TimedeltaIndex`: Immutable ndarray of timedelta64 data, represented internally as int64, and which can be boxed to timedelta objects.  
- `PeriodIndex`: Immutable ndarray holding ordinal values indicating regular periods in time. 

Indexes are unique and meaningful identifier for each row  

Also note that the .columns attribute returns an index containg the column names of df  

### DataFrame Indexing

`DataFrame.loc`: Access a group of rows and columns by label(s) or a boolean array. We have to specify the name of the rows and columns Or Boolean Array
`DataFrame.iloc`: On the other hand, iloc is integer index-based. So here, we have to specify rows and columns by their integer index.  
`DataFrame.at`: Access a single value for a row/column label pair. 
`DataFrame.iat` : Access a single value for a row/column pair by integer position.  

https://pandas.pydata.org/pandas-docs/version/1.0.1/reference/frame.html#indexing-iteration

Convert the column of a dataframe into its index
You can make a column, the index of the DataFrame using the .set_index() method (n.b. inplace=True means you're actually altering the DataFrame df inplace)  
df.set_index(pd.DatetimeIndex(df['date']), inplace=True)  

#### Multiindex:  
df.set_index(['date', 'language'], inplace=True)  # This creates a multiindex
To be able to slice with a multi-index, you need to sort the index first  
df.sort_index(inplace=True)  
df.loc[('2017-01-02', 'r')]  

### groupby leads to index









