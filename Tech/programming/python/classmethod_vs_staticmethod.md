### @classmethod vs @staticmethod and def methods


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
