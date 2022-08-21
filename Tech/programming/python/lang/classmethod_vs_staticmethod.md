### Class Instance
Creating a class creates a class instance.Each class instance can have attributes attached to it for maintaining its state. Class instances can also have methods (defined by its class) for modifying its state.  

### Object Instance
Creating an object of a class creates an object instance.  
Object instance can be its own instance variables


Python offers three types of methods namely instance, class and static methods. 


### @classmethod vs @staticmethod and instance methods

In the example below

*INSTANCE METHOD*  
`compute_on_char_num` is an instance method since it uses the instance variable `chars_num`  

*CLASS METHOD*    
`radomize` is a class method since it uses only class attributes.  
It  has access to the Randomize class instance however does not have access to the object instance.      
The first argument to it is cls by convention which is the class.  

*STATIC METHOD*   
`get_color` is a static method  
It uses no class data. It is primarily used to namespace the method  
It can be called as Randomize.get_color() or obj.get_color()  . 
No self/cls arguments are pass to it.


```python
import random


class Randomize:
    RANDOM_CHOICE = 'abcdefg'

    def __init__(self, chars_num):
        self.chars_num = chars_num

    def compute_on_char_num(self):
        return len(self.chars_num)
    
    # since randomize method is not using any instance variables declared in init
    # it can be class method
    @classmethod
    def randomize(cls, random_chars=3):
        return ''.join(random.choice(cls.RANDOM_CHOICE)
                       for _ in range(random_chars))
    
    # static methods use no class data
    @staticmethod
    def get_color():
        return "red"
```
