### Class attribute vs Property

With a property you have complete control on its getter, setter and deleter methods, which you don't have (if not using caveats) with an attribute.

```python
class A(object):
    _x = 0
    '''A._x is an attribute'''

    @property
    def x(self):
        '''
        A.x is a property
        This is the getter method
        '''
        return self._x

    @x.setter
    def x(self, value):
        """
        This is the setter method
        where I can check it's not assigned a value < 0
        """
        if value < 0:
            raise ValueError("Must be >= 0")
        self._x = value

>>> a = A()
>>> a._x = -1
>>> a.x = -1
Traceback (most recent call last):
  File "ex.py", line 15, in <module>
    a.x = -1
  File "ex.py", line 9, in x
    raise ValueError("Must be >= 0")
ValueError: Must be >= 0
```
