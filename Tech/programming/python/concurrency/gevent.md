gevent is a coroutine-based cooperative multitasking python framework that relies on monkey patching to make all code cooperative.   
https://eng.lyft.com/what-the-heck-is-gevent-4e87db98a8  

Below we have a full example using gevent - we first monkey patch the standard library which then magically makes time.sleep cooperative - instead of blocking the CPU it yields control for at least the sleep time. No other code changes were required. gevent avoids callback hell by monkey patching the standard library, automatically creating coroutines - effectively resumption of work at the yield point. 

```python
from gevent import monkey
monkey.patch_all()

import gevent
import time

def send_stat():
    time.sleep(0.001)
    
def do_thing(name):
    print(f'{name}: Doing first step')
    print(f'{name}: Doing second step')
    send_stat()
    print(f'{name}: Doing third step')
    
def do_things(name):
    do_thing(name)
    
gevent.joinall([gevent.spawn(do_things, x) for x in range(2)])
```

Gevent Correctness  
https://eng.lyft.com/gevent-part-2-correctness-22e3b7998382  


