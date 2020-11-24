https://stackabuse.com/unpacking-in-python-beyond-parallel-assignment  

* is list unpacking operator  
** is dict unpacking operator  

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
