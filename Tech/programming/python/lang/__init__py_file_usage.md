### Creating packages in python 2
python3 supports implicit names spaces packages that allows it to create a package without an __init__.py

### Object initialization upon module import 
When a regular package is imported, its __init__.py file is implicitly executed, and the objects it defines are bound to names in the package’s namespace. 

Thus __init__.py allows you to define any variable at the package level. 

_init__.py files should be very thin to avoid violating the "explicit is better than implicit" philosophy.

### References
https://stackoverflow.com/a/29509611

There are 2 main reasons for __init__.py

For convenience: the other users will not need to know your functions' exact location in your package hierarchy.

```bash
your_package/
  __init__.py
  file1.py
  file2.py
    ...
  fileN.py
# in __init__.py
from file1 import *
from file2 import *
...
from fileN import *
# in file1.py
def add():
    pass

```
    
then others can call add() by

```bash
from your_package import add
```

without knowing file1, like


```bash
from your_package.file1 import add
```

If you want something to be initialized; for example, logging (which should be put in the top level):

```bash
import logging.config
logging.config.dictConfig(Your_logging_config)
```
