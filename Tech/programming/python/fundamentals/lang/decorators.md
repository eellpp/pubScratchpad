https://realpython.com/primer-on-python-decorators/  

- They can be reused.
- They can decorate functions with arguments and return values.
- They can use @functools.wraps to look more like the decorated function.

how to:  
- Decorate classes
- Nest decorators
- Add arguments to decorators
- Keep state within decorators
- Use classes as decorators


#### Creating Singletons
```bash
import threading
from functools import wraps

def singleton(cls):
    instances = {}
    lock = threading.Lock()

    @wraps(cls)
    def get_instance(*args, **kwargs):
        # 1. If instance already exists → return immediately (very fast)
        if cls not in instances:
            with lock:       # 2. take locks only when instances not created yet.
                if cls not in instances: # only when instace not created yet, if race condition at 1, then need double check
                    instances[cls] = cls(*args, **kwargs)
        return instances[cls]

    return get_instance

```


```bash
@singleton
class Database:
    def __init__(self):
        print("Connecting…")

db1 = Database()
db2 = Database()

print(db1 is db2)   # True

```

#### Timing Functions  
```bash
def timer(func):
    """Print the runtime of the decorated function"""
    @functools.wraps(func)
    def wrapper_timer(*args, **kwargs):
        start_time = time.perf_counter()    # 1
        value = func(*args, **kwargs)
        end_time = time.perf_counter()      # 2
        run_time = end_time - start_time    # 3
        print(f"Finished {func.__name__!r} in {run_time:.4f} secs")
        return value
    return wrapper_timer
```

#### Registering Plugins  
The main benefit of this simple plugin architecture is that you do not need to maintain a list of which plugins exist. That list is created when the plugins register themselves. This makes it trivial to add a new plugin: just define the function and decorate it with @register.  
```bash
import random
PLUGINS = dict()

def register(func):
    """Register a function as a plug-in"""
    PLUGINS[func.__name__] = func
    return func

@register
def say_hello(name):
    return f"Hello {name}"

@register
def be_awesome(name):
    return f"Yo {name}, together we are the awesomest!"

def randomly_greet(name):
    greeter, greeter_func = random.choice(list(PLUGINS.items()))
    print(f"Using {greeter!r}")
    return greeter_func(name)
```

#### Is the User Logged In?
```bash
from flask import Flask, g, request, redirect, url_for
import functools
app = Flask(__name__)

def login_required(func):
    """Make sure user is logged in before proceeding"""
    @functools.wraps(func)
    def wrapper_login_required(*args, **kwargs):
        if g.user is None:
            return redirect(url_for("login", next=request.url))
        return func(*args, **kwargs)
    return wrapper_login_required

@app.route("/secret")
@login_required
def secret():
```



#### Caching Return Values
```bash
import functools
from decorators import count_calls

def cache(func):
    """Keep a cache of previous function calls"""
    @functools.wraps(func)
    def wrapper_cache(*args, **kwargs):
        cache_key = args + tuple(kwargs.items())
        if cache_key not in wrapper_cache.cache:
            wrapper_cache.cache[cache_key] = func(*args, **kwargs)
        return wrapper_cache.cache[cache_key]
    wrapper_cache.cache = dict()
    return wrapper_cache

@cache
@count_calls
def fibonacci(num):
    if num < 2:
        return num
    return fibonacci(num - 1) + fibonacci(num - 2)
``` 

## Expressions added in python 3.9 

#### Role-Based Access Control (RBAC)

Expression needed because the decorator needs arguments (role name) 

```bash
def require_role(role):
    def deco(fn):
        def wrapper(user, *a, **k):
            if role not in user.roles:
                raise PermissionError(f"Requires role: {role}")
            return fn(user, *a, **k)
        return wrapper
    return deco


@require_role("admin")        # expression call
def delete_user(user, id):
    ...

```

#### Conditional expressions 

```python
def enabled(fn):
    def wrapper(*a, **k):
        return fn(*a, **k)
    return wrapper

def disabled(fn):
    def wrapper(*a, **k):
        print("Feature disabled")
    return wrapper


FEATURE_ENABLED = False

@(enabled if FEATURE_ENABLED else disabled)   # conditional expression
def new_checkout():
    ...

```


#### Dependency Injection 

With expressionm dependency isn’t a hardcoded decorator name.

```def inject(service):
    def deco(fn):
        def wrapper(*a, **k):
            return fn(service(), *a, **k)
        return wrapper
    return deco


from myapp.services import PaymentService

@inject(PaymentService)     # expression = class ref
def checkout(payment_service):
    ...
python

```

Decorator expressions matter when you need:  
✔ configuration (rate, retries, roles…)   
✔ conditional enable/disable  
✔ environment-driven behavior  
✔ dynamic lookup (dicts, lists, modules, classes)  
✔ clean, reusable cross-cutting concerns  

