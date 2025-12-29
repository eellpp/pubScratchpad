How to create a quick dataframe in pandas for testing.   

```python
import string
import random
pandas.DataFrame({'col1': pandas.Series(random.sample(string.ascii_letters,10)),
                  'col2': pandas.Series(random.sample(string.ascii_letters,10)),
                  'col3': pandas.Series(random.sample(range(10000),10))
                  
                 })
```

