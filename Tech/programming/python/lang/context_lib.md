The contextlib module of Python’s standard library provides utilities for resource allocation to the with statement.  

```python
class myFileHandler():
    def __init__(self, fname, method):
        print("I'm in contructor")
        self.file_obj = open(fname, method)
    def __enter__(self):
        print("I'm in ENTER block")
        return self.file_obj
    def __exit__(self, type, value, traceback):
        print("I'm in EXIT block")
        self.file_obj.close()

with myFileHandler("this_file.txt", "w") as example:
  ######### read write statements #########
  print("I'm in WITH block")
  pass
 ```
 
 Using Context Lib
 ```python
 from contextlib import contextmanager

@contextmanager
def thisFunc(fname, method):
  print("This is the implicit ENTER block")
  my_file = open(fname, method)

  yield my_file
  
  print("This is the implicit EXIT block")
  my_file.close()


with thisFunc("this_file.txt", "w") as example:
  ######### read write statements #########
  print("I'm in WITH block")
  pass
 ```
 
 https://www.educative.io/edpresso/what-is-the-contextlib-module  
 
 
