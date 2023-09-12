Reference
https://github.com/DopplerHQ/awesome-interview-questions#python


**What is named tuple ?** 

_Python's namedtuple_ was created to improve code readability by providing a way to access values using descriptive field names instead of integer indices,

```python
>>> from collections import namedtuple

>>> # Create a namedtuple type, Point
>>> Point = namedtuple("Point", "x y")
>>> issubclass(Point, tuple)
True

>>> # Instantiate the new type
>>> point = Point(2, 4)
>>> point
Point(x=2, y=4)

>>> # Dot notation to access coordinates
>>> point.x
2
>>> point.y
4
```
**What is use of typename in namedtuple ?**
When you create a named tuple, a class with this name (typename) gets created internally.

```python
from collections import namedtuple

Point = namedtuple('whatsmypurpose',['x','y'],verbose=True)
p = Point(11,22)
type(p) # __main__.whatsmypurpose
```


Q: How to package code in Python?

Q: What is a package manager? What package managers do you know and which one do you recommend?

**What are virtualenvs?**
A virtual env has python interpretor , libraries and scripts installed into it so that its isolated from other virtual env

What advantages do NumPy arrays offer over (nested) Python lists?

You have a memory leak in the working production application on one of your company servers. How would you start debugging it?

**What is the `yield` keyword used for in Python?**
Yield can be used like a return statement in function. Instead of returning the output it will return a generator that can be iterated upon

**What is an iterator in Python?**
An iterable is an object capable of **returning** its **members** **one by one**. Said in other words, an iterable is anything that you can loop over with a `for` loop in Python.

**Can you define a funcition inside function in python ?**
It’s possible to [define functions](https://realpython.com/defining-your-own-python-function/) _inside other functions_. Such functions are called [inner functions](https://realpython.com/inner-functions-what-are-they-good-for/).

**Can you return a function from function ?**
Python also allows you to use functions as return values. For eg a inner function can be returned from a function


**What is a decorator ?**
A decorator is a function that takes another function and extends the behavior of the latter function without explicitly modifying it.

decorators wrap a function, modifying its behavior.


```
def my_decorator(func):
    def wrapper():
        print("Something is happening before the function is called.")
        func()
        print("Something is happening after the function is called.")
    return wrapper

def say_whee():
    print("Whee!")

say_whee = my_decorator(say_whee)
```


```
def my_decorator(func):
    def wrapper():
        print("Something is happening before the function is called.")
        func()
        print("Something is happening after the function is called.")
    return wrapper

@my_decorator
def say_whee():
    print("Whee!")
```


**What is `unittest` module in Python? How to write tests in Python?**

What are `*args` and `**args` ?
  \*args  will give your function params as a tuple 
\*\*args will give the params for the named arguments


**what is lambda in python ?**
Anonymous function that can be created at run time

**What is difference between tuple and list ?**
- Tuple are immutable. 
- tuples use parentheses for enclosing, but the lists have square brackets in their syntax.

**Get unique elements from a list ?**

Pandas:
- how do check if data frame is null or exists 
- how would you change each column of dataframe
-

How to sort the dataframe by columns ?
> df.sort_values()


**What is difference between fork and spawn in multiprrocessing module**

### How to read a streaming data in python with requests modules

```python
res = requests.get(url,stream=True)

for line in res.iter_lines():
    print(line.decode('UTF-8'))
```

Above you would keep processing the lines before the server has ended sending it. 

