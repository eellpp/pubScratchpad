### What is __main__.py?

https://stackoverflow.com/questions/4042905/what-is-main-py

You can also create a directory or zipfile full of code, and include a __main__.py. Then you can simply name the directory or zipfile on the command line, and it executes the __main__.py automatically 

### Basics about logging module, root logger and custom logger

https://realpython.com/python-logging/

### Difference between __init__.py and __main__.py
__init__.py is run when you import a package into a running python program. For instance, import idlelib within a program, runs idlelib/__init__.py, which does not do anything as its only purpose is to mark the idlelib directory as a package. On the otherhand, tkinter/__init__.py contains most of the tkinter code and defines all the widget classes.  

__main__.py is run as '__main__' when you run a package as the main program. For instance, python -m idlelib at a command line runs idlelib/__main__.py, which starts Idle.   

