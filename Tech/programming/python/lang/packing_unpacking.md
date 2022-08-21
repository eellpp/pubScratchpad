https://stackabuse.com/unpacking-in-python-beyond-parallel-assignment  

keyword * is list unpacking operator  
keyword ** is dict unpacking operator  

**tuple unpacking**
```python
>>> (a, b, c) = (1, 2, 3)
>>> a
1
>>> b
2
>>> c
3

>>> (a, b, c) = 1, 2, 3
>>> a, b, c = (1, 2, 3)
>>> a, b, c = 1, 2, 3
```

**Unpacking iterables**
```python
>>> # Unpacking strings
>>> a, b, c = '123'
>>> a
'1'
>>> b
'2'
>>> c
'3'
>>> # Unpacking lists
>>> a, b, c = [1, 2, 3]
>>> a
1
>>> b
2
>>> c
3
>>> # Unpacking generators
>>> gen = (i ** 2 for i in range(3))
>>> a, b, c = gen
>>> a
0
>>> b
1
>>> c
4
>>> # Unpacking dictionaries (keys, values, and items)
>>> my_dict = {'one': 1, 'two':2, 'three': 3}
>>> a, b, c = my_dict  # Unpack keys
>>> a
'one'
>>> b
'two'
>>> c
'three'
>>> a, b, c = my_dict.values()  # Unpack values
>>> a
1
>>> b
2
>>> c
3
>>> a, b, c = my_dict.items()  # Unpacking key-value pairs
>>> a
('one', 1)
>>> b
('two', 2)
>>> c
('three', 3)

>>> x, y, z = range(3)
>>> x
0
>>> y
1
>>> z
2
```

**set unpacking**
```python
>>> a, b, c = {'a', 'b', 'c'}
>>> a
'c'
>>> b
'b'
>>> c
'a'
```

**Packing With the * Operator**
```python
>>> *a, = 1, 2
>>> a
[1, 2]

>>> a, *b = 1, 2, 3
>>> a
1
>>> b
[2, 3]

#Packing no values in a (a defaults to []) because b, c, and d are mandatory:  
>>> *a, b, c, d = 1, 2, 3
>>> a
[]
>>> b
1
>>> c
2
>>> d
3
```


**unpacking generator expression**
```python
>>> gen = (2 ** x for x in range(10))
>>> gen
<generator object <genexpr> at 0x7f44613ebcf0>
>>> *g, = gen
>>> g
[1, 2, 4, 8, 16, 32, 64, 128, 256, 512]
>>> ran = range(10)
>>> *r, = ran
>>> r
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

**Assigning multiple variables**
```python
>>> name, age, job = ["John Doe", "40", "Software Engineer"]
>>> name
'John Doe'
>>> age
40
>>> job
'Software Engineer'

**Collecting multiple values to a variable**
```python
>>> seq = [1, 2, 3, 4, 5, 6]
>>> first, *body, last = seq
>>> first, body, last
(1, [2, 3, 4, 5], 6)

>>> *head, a, b = range(5)
>>> head, a, b
([0, 1, 2], 3, 4)
>>> a, *body, b = range(5)
>>> a, body, b
(0, [1, 2, 3], 4)
>>> a, b, *tail = range(5)
>>> a, b, tail
(0, 1, [2, 3, 4])

# Drop unnecessary variables
>>> a, b, *_ = 1, 2, 0, 0, 0, 0
>>> a
1
>>> b
2
>>> _
[0, 0, 0, 0]

>>> import sys
>>> sys.version_info
sys.version_info(major=3, minor=8, micro=1, releaselevel='final', serial=0)
>>> mayor, minor, micro, *_ = sys.version_info
>>> mayor, minor, micro
(3, 8, 1)

>>> def powers(number):
...     return number, number ** 2, number ** 3

>>> *_, cube = powers(2)
>>> cube
8
```  

**merging iterables**
```python
>>> my_tuple = (1, 2, 3)
>>> (0, *my_tuple, 4)
(0, 1, 2, 3, 4)
>>> my_list = [1, 2, 3]
>>> [0, *my_list, 4]
[0, 1, 2, 3, 4]
>>> my_set = {1, 2, 3}
>>> {0, *my_set, 4}
{0, 1, 2, 3, 4}
>>> [*my_set, *my_list, *my_tuple, *range(1, 4)]
[1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3]
>>> my_str = "123"
>>> [*my_set, *my_list, *my_tuple, *range(1, 4), *my_str]
[1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 2, 3, '1', '2', '3']
```

**Dictionary unpacking operator**  
 if the dictionaries we're trying to merge have repeated or common keys, then the values of the right-most dictionary will override the values of the left-most dictionary.  
 
```python
>>> numbers = {"one": 1, "two": 2, "three": 3}
>>> letters = {"a": "A", "b": "B", "c": "C"}
>>> combination = {**numbers, **letters}
>>> combination
{'one': 1, 'two': 2, 'three': 3, 'a': 'A', 'b': 'B', 'c': 'C'}
```

**unpacking for loop**
```python
>>> sales = [("Pencil", 0.22, 1500), ("Notebook", 1.30, 550), ("Eraser", 0.75, 1000)]
>>> for product, price, sold_units in sales:
...     print(f"Income for {product} is: {price * sold_units}")

>>> for first, *rest in [(1, 2, 3), (4, 5, 6, 7)]:
...     print("First:", first)
...     print("Rest:", rest)
...

**packing and unpacking in functions**

```python
>>> def func(required, *args, **kwargs):
...     print(required)
...     print(args)
...     print(kwargs)
...
>>> func("Welcome to...", 1, 2, 3, site='StackAbuse.com')
Welcome to...
(1, 2, 3)
{'site': 'StackAbuse.com'}

>>> def func(welcome, to, site):
...     print(welcome, to, site)
...
>>> func(*["Welcome", "to"], **{"site": 'StackAbuse.com'})
Welcome to StackAbuse.com

>>> def func(required, *args, **kwargs):
...     print(required)
...     print(args)
...     print(kwargs)
...
>>> func("Welcome to...", *(1, 2, 3), **{"site": 'StackAbuse.com'})
Welcome to...
(1, 2, 3)
{'site': 'StackAbuse.com'}
```


