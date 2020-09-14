### Package vs module vs class
A module is a Python file that (generally) has only definitions of variables, functions, and classes.
To import all the variables, functions and classes from moduletest.py into another program you are writing, we use the import operator. 

```bash
import moduletest
# import only required objects
from moduletest import ageofqueen
from moduletest import printhello
```
`Class`:
A module can consist of multiple classes or functions.

`Package`:
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

### Class Syntax
The syntax for a subclass definition looks like this:
```bash
class BaseClass:
  Body of base class

class DerivedClass(BaseClass):

  def __init__(self, first, last):
        self.firstname = first
        self.lastname = last

class MultiDerived(Base1, Base2):
    pass
 ```
 
 `__init__` is a special method in Python classes, it is the constructor method for a class.
 
 `self` represents the instance of the class. By using the "self" keyword we can access the attributes and methods of the class in python.
 
 Every class in Python is derived from the class object. It is the most base type in Python.

In the multiple inheritance scenario, any specified attribute is searched first in the current class. If not found, the search continues into parent classes in depth-first, left-right fashion without searching same class twice.
 
 `super` : Use super() to access the base class 
 
### Script vs Module 
Scripts are top level files intended for execution and  
Modules are intended to be imported  
