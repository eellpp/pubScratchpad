### What are index in dataframe
Like a dict, a DataFrame's index is backed by a hash table. Looking up rows based on index values is like looking up dict values based on a key.  
In contrast, the values in a column are like values in a list.

Many functions, such as set_index, stack, unstack, pivot, pivot_table, melt, lreshape, and crosstab, all use or manipulate the index. Sometimes we want the DataFrame in a different shape for presentation purposes, or for join, merge or groupby operations. (As you note joining can also be done based on column values, but joining based on the index is faster.) Behind the scenes, join, merge and groupby take advantage of fast index lookups when possible.

Time series have resample, asfreq and interpolate methods whose underlying implementations take advantage of fast index lookups too.

When to Index in group operations :  
For sufficiently large DataFrames, grouping by the index is faster than grouping on column values. For small DataFrames, grouping on column values can actually be faster. Moreover, calling set_index to convert a column to an index level also takes time, so either the DataFrame has to be sufficiently large or there has to be multiple groupby operations (thus amortizing the cost of calling set_index) to make grouping by the index pay off.  


### Different types of indexes

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

### groupby leads to index and multi index  
```bash
>>> df = pandas.DataFrame([('bird', 'Falconiformes', 389.0),('bird', 'Psittaciformes', 24.0),('mammal', 'Carnivora', 80.2),
                   ('mammal', 'Primates', np.nan),('mammal', 'Carnivora', 58)],
                  columns=('class', 'order', 'max_speed'))
>>> df
  class	order	max_speed
0	bird	Falconiformes	389.0
1	bird	Psittaciformes	24.0
2	mammal	Carnivora	80.2
3	mammal	Primates	NaN
4	mammal	Carnivora	58.0           

### gives an index class
>>> df[["class","max_speed"]].groupby(["class"]).max()
      max_speed
class	
bird	389.0
mammal	80.2

### gives multindex : class and order
>>> df.groupby(["class","order"]).max()
              max_speed
class	order	
bird	Falconiformes	389.0
Psittaciformes	24.0
mammal	Carnivora	80.2
Primates	NaN

## move back the index/multi index to columns of dataframe
>>> d = df.groupby(["class","order"]).max()
>>> d.reset_index()  
  class	order	max_speed
0	bird	Falconiformes	389.0
1	bird	Psittaciformes	24.0
2	mammal	Carnivora	80.2
3	mammal	Primates	NaN

```









