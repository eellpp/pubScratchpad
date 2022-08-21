### What is purpose of __name__ variable 
__name__ variable holds the name of module  
However if the module is run directly, then the variable __name__ is set to "__main__"  
This is one way of finding out whether the module is running directly or is being imported from some module.  


### What is relative import
from . import mymodule  
```bash
.
├── package
│   ├── __init__.py
│   ├── module.py
│   └── standalone.py
```
All of the files in package begin with the same 2 lines of code:

from pathlib import Path
print('Running' if __name__ == '__main__' else 'Importing', Path(__file__).resolve())
I'm including these two lines only to make the order of operations obvious. We can ignore them completely, since they don't affect the execution.  

__init__.py and module.py contain only those two lines (i.e., they are effectively empty).  

standalone.py additionally attempts to import module.py via relative import:

from . import module  # explicit relative import  
We're well aware that /path/to/python/interpreter package/standalone.py will fail. However, we can run the module with the -m command line option that will "search sys.path for the named module and execute its contents as the __main__ module":  

```bash
vaultah@base:~$ python3 -i -m package.standalone
Importing /home/vaultah/package/__init__.py
Running /home/vaultah/package/standalone.py
Importing /home/vaultah/package/module.py
>>> __file__
'/home/vaultah/package/standalone.py'
>>> __package__
'package'
>>> # The __package__ has been correctly set and module.py has been imported.
... # What's inside sys.modules?
... import sys
>>> sys.modules['__main__']
<module 'package.standalone' from '/home/vaultah/package/standalone.py'>
>>> sys.modules['package.module']
<module 'package.module' from '/home/vaultah/package/module.py'>
>>> sys.modules['package']
<module 'package' from '/home/vaultah/package/__init__.py'>
```
