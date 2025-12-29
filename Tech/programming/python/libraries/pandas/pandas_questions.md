
**What are the different data structures in pandas ?** 
Dataframe and Series. 

**How are numpy array different from pandas Series ?**. 
Numpy array has default integer index. Series can have labels as index.   

**Can a dataframe have multiple index ? How to filter on multiindex ?**. 

**How to convert one of the columns of dataframe into a index and vice-versa ?** 
reset_index(): to convert index to column. 
set_index(): column to index   

**How to select few columns of dataframe ?**
> df[ list_of_column_names].  

> df.filter(items= list_of_column_names)

**How to select dataframe based on value of cell**
> df[df["column"] == "value" ].   
If the column to searched, is already indexed then we can use.  
df.filter(items = list_Of_values, axis = 0) # add reset_index or instead while set_index creation set drop=False. 

If multi cols .   
df[(df["column1"] == "value") & df["column2"] == "value"].   
If both column availables as index   
df.filter(items = [(v11,v21), (v21,v22) ] , axis = 0).  







