A categorical or discrete variable is one that has two or more categories (values).  There are two types of categorical variable, nominal and ordinal.  A nominal variable has no intrinsic ordering to its categories. For example, gender is a categorical variable having two categories (male and female) with no intrinsic ordering to the categories. An ordinal variable has a clear ordering. For example, temperature as a variable with three orderly categories (low, medium and high). A frequency table is a way of counting how often each category of the variable in question occurs. It may be enhanced by the addition of percentages that fall into each category.  

All values of categorical data are either in categories or np.nan.  
Numerical operations are not possible on catagorical variables (add, sub ..)    

- size of the dataframe is reduced by converting values to categorical data types
- group by operations are many fold faster on catagorical values  


1. Do not assume you need to convert all categorical data to the pandas category data type.  
2. If the data set starts to approach an appreciable percentage of your useable memory, then consider using categorical data types.  
3. If you have very significant performance concerns with operations that are executed frequently, look at using categorical data.  
4. If you are using categorical data, add some checks to make sure the data is clean and complete before converting to the pandas category type. Additionally, check for NaN values after combining or converting dataframes.  


*User Guide*  
https://pandas.pydata.org/pandas-docs/stable/user_guide/categorical.html  


#### Converting columns of dataframe to category
```python
from pandas.api.types import CategoricalDtype
s = pd.Series(["a", "b", "c", "a"])
cat_type = CategoricalDtype(categories=["b", "c", "d"],
   ....:                             ordered=True)
```


References:  
1. [Using The Pandas Category Data Type](https://pbpython.com/pandas_dtypes_cat.html)


