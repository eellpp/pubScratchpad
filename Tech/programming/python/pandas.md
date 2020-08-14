### Difference between reindex , set_index , resetindex

### Adding a new empty column to dataframe
df.reindex(columns = header_list)    
columns not in header_list will be added as blank cells  

### Creating Null values in pandas Dataframe
Use numpy.nan    
pandas.Dataframe([{'a':123,'b':'456'},{'a':789,'b':numpy.nan} ])  
