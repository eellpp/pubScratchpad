
### Package vs module vs class
A Python module is simply a Python source file, which can expose classes, functions and global variables.

When imported from another Python source file, the file name is treated as a namespace.

A Python package is simply a directory of Python module(s).

For example, imagine the following directory tree in /usr/lib/python/site-packages:
```bash
mypackage/__init__.py <-- this is what tells Python to treat this directory as a package

mypackage/mymodule.py

So then you would do:

import mypackage.mymodule
or
from mypackage.mymodule import myclass
```
