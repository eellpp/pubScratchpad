### Iterators
An iterator is an object with a  __next__ (Python 3) method.

```python
>>> s = 'cat'      # s is an ITERABLE
                   # s is a str object that is immutable
                   # s has no state
                   # s has a __getitem__() method 

>>> t = iter(s)    # t is an ITERATOR
                   # t has state (it starts by pointing at the "c"
                   # t has a next() method and an __iter__() method

>>> next(t)        # the next() function returns the next value and advances the state
'c'
>>> next(t)        # the next() function returns the next value and advances
'a'
```

### Generator
generator is a subclass of iterator. All generators are iterators.   
Using yield will result in a generator object.  


```python
def csv_reader(file_name):
    for row in open(file_name, "r"):
        yield row
```


### Generator Expression
Like list comprehension. With Brackets instead of []

```python
csv_gen = (row for row in open(file_name))
```


### Generator Pipeline

```python
def fibonacci_numbers(nums):
    x, y = 0, 1
    for _ in range(nums):
        x, y = y, x+y
        yield x

def square(nums):
    for num in nums:
        yield num**2

print(sum(square(fibonacci_numbers(10))))
```


```python
file_name = "techcrunch.csv"
lines = (line for line in open(file_name))
list_line = (s.rstrip()split(",") for s in lines)
cols = next(list_line)
company_dicts = (dict(zip(cols, data)) for data in list_line)
funding = (
    int(company_dict["raisedAmt"])
    for company_dict in company_dicts
    if company_dict["round"] == "a"
)
total_series_a = sum(funding)
print(f"Total series A fundraising: ${total_series_a}")
```

You aren’t iterating through all these at once in the generator expression. In fact, you aren’t iterating through anything until you actually use a for loop or a function that works on iterables, like sum() at end.  

