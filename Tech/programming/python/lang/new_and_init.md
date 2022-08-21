## __new__ and __init__

https://howto.lintel.in/python-__new__-magic-method-explained  

- First __new__ is called with the class instance  
- Then __init__ is called to initialize the class instance.  

The magic method __new__ will be called when instance is being created. Using this method you can customize the instance creation. This is only the method which will be called first then __init__ will be called to initialize instance when you are creating instance.  

```python
class Foo(object):
    def __new__(cls, *args, **kwargs):
        print "Creating Instance"
        instance = super(Foo, cls).__new__(cls, *args, **kwargs)
        return instance
 
    def __init__(self, a, b):
        self.a = a
        self.b = b
 
    def bar(self):
        pass
>>> i = Foo(2, 3)
Creating Instance
```

## Application

### Singleton Pattern
```python
class Singleton(object):
    _instance = None  # Keep instance reference 
    
    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = object.__new__(cls, *args, **kwargs)
        return cls._instance
```

Other Applications  
```python
class LimitedInstances(object):
    _instances = []  # Keep track of instance reference
    limit = 5 
 
    def __new__(cls, *args, **kwargs):
        if not len(cls._instances) <= cls.limit:
            raise RuntimeError, "Count not create instance. Limit %s reached" % cls.limit    
        instance = object.__new__(cls, *args, **kwargs)
        cls._instances.append(instance)
        return instance
    
    def __del__(self):
        # Remove instance from _instances 
        self._instance.remove(self)

```

### __new__ function 
Suppose we have function:
```python
class Foobar:
    def __new__(cls):
        return super().__new__(cls)
 ```
 Foobar.__new__ is used to create instances of Foobar  
type.__new__ is used to create the Foobar class (an instance of type in the example)  

https://docs.python.org/3/library/functions.html?highlight=type#type   
type(name, bases, dict)  
With three arguments, return a new type object. This is essentially a dynamic form of the class statement. The name string is the class name and becomes the __name__ attribute; the bases tuple itemizes the base classes and becomes the __bases__ attribute; and the dict dictionary is the namespace containing definitions for class body and is copied to a standard dictionary to become the __dict__ attribute. 

For example, the following two statements create identical type objects:

```python
class X:
    a = 1

X = type('X', (object,), dict(a=1))
```

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
```
