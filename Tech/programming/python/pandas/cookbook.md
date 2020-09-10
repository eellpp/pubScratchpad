### Difference between reindex , set_index , resetindex

### Adding a new empty column to dataframe
df.reindex(columns = header_list)    
columns not in header_list will be added as blank cells  

### Creating Null values in pandas Dataframe
Use numpy.nan    
pandas.Dataframe([{'a':123,'b':'456'},{'a':789,'b':numpy.nan} ])  

### Change datatypes of column
df[col] = df[col].astype(str)  
Here we are using the series function  

### Changing pandas column to datetime
use pandas.to_datetime  
https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.to_datetime.html#pandas.to_datetime  
pd.to_datetime(df.col, format='%Y%m%d')  

### Removing duplicate from dataframe


