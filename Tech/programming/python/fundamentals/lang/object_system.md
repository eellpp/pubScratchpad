
https://tenthousandmeters.com/blog/python-behind-the-scenes-6-how-python-object-system-works/  


In Python, every object has an identity, a type and a value. An object’s identity never changes once it has been created; you may think of it as the object’s address in memory. The ‘is’ operator compares the identity of two objects; the id() function returns an integer representing its identity.

Once an object’s reference count drops to zero and it is garbage collected, then its identifying number becomes available and may be used again.

The built-in Python function id() returns an object’s integer identifier. Using the id() function, you can verify that two variables indeed point to the same object.

### Everything is object
Everything in Python is an object.   
Lists are objects. 42 is an object. Modules are objects. Functions are objects. Python bytecode is also kept in an object.  
All of these have types and unique IDs

### Types
So, every object in Python has a type. Its type can be discovered by calling the type builtin function [2]. The type is an object too, so it has a type of its own, which is called type.
```bash
>>> type(42)
<class 'int'>
>>> type(type(42))
<class 'type'>
>>> type(type(type(42)))
<class 'type'>
``` 
In general, the type of any new-style class is type. For that matter, the type of type is type as well   


### classes
a class is a mechanism Python gives us to create new user-defined types from Python code.

### Metaclass
Since everthing is an object, even class is an object.  
type is a metaclass, of which classes are instances.  
Just as an ordinary object is an instance of a class, all classes in Python 3 are an an instance of the type metaclass.

```bash
>>> class Foo:
...     pass
...
>>> x = Foo()

```
x is an instance of class Foo.  
Foo is an instance of the type metaclass.  
type is also an instance of the type metaclass, so it is an instance of itself.  

### Creating a class dynamically
Since class is also an instance of type, we can create a class (and its objects) dynamically

```bash
>>> Foo = type('Foo', (), {})

>>> x = Foo()
>>> x
<__main__.Foo object at 0x04CFAD50>

>>> Bar = type('Bar', (Foo,), dict(attr=100))

>>> x = Bar()
>>> x.attr
100
>>> x.__class__
<class '__main__.Bar'>
>>> x.__class__.__bases__
(<class '__main__.Foo'>,)

```

### Using Metaclass to create a Registry Pattern

### Registry Application
The base class class get registed in the RegistyHolder
```python
class RegistryHolder(type):

    REGISTRY = {}

    def __new__(cls, name, bases, attrs):
        new_cls = type.__new__(cls, name, bases, attrs)
        """
            Here the name of the class is used as key but it could be any class
            parameter.
        """
        cls.REGISTRY[new_cls.__name__] = new_cls
        return new_cls
"""
Define a new class Foo and specify that its metaclass is the custom metaclass Meta, rather than the standard metaclass type. 
This is done using the metaclass keyword in the class definition as follows:

"""

class Foo(metaclass=RegistryHolder):
     pass

```

Now on creation of class Foo, it will register automatically with Registry holder where custom logic can be kept for  
object references etc. Since __new__ is called before __init__




