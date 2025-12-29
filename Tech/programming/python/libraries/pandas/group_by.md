Some common dataframe operations 

- group by columns and get subgroup based on some value  
```python
g = df.groupby(["col1","col2"])  
g.get_group(("A","Y"))  
g.get_group("A")  
```

- grouby columns and count in each group, order by desc
- grouby columns and select max value of some other column in each group
- groupby columns and sum of some other column

If you group by columns A and B, 


#### Python Pandas Tutorial (Part 8): Grouping and Aggregating - Analyzing and Exploring Your Data
https://www.youtube.com/watch?v=txMdrV1Ut64  
- get_group
- series operation
- multi index
- pd.concat for creating dataframes with multiple series having same index 
- value_counts 


