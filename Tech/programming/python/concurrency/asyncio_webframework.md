
### When async can help 
If the flask application is calling other microservices or doing some other I/O tasks. Then the async routes will be of much help by utilizing the CPU process and thread to the fullest.

### flask async limitations
For asyncio to work in the flask, we must satisfy the prerequisites.
- python version > 3.6
- Remove all blocking code inside the route
- pip install "Flask[async]"

### What are major async frameworks in python 
Quart is a reimplementation of the Flask API using async and await thereby being the ASGI version of Flask.  
FastAPI extends Starlette which is a microframework like Flask and Quart.   
Starlette is also an ASGI microframework.  

Quart and Starlette as ASGI frameworks work with Uvicorn, which is the fastest ASGI server.  

### How WSGi differs from ASGI
WSGI Handles requests in a sequential (synchronous) manner; a wsgi server (eg: gunicorn) receives a request and executes each task in that request in a sequential manner, and only once all tasks in that request is completed it then moves on to the next one.

However, there may not be much of a difference in individual request handling time between the two.
- Request handling times for I/O operations maybe faster for ASGI applications, however for CPU bound operations the difference in handling times may not be much.
- The advantage of concurrency provided by ASGI servers may not be that evident during low traffic period.


### Using sync and async functions with ASGI

When using ASGI, you’ll want to use async functions, and async-friendly libraries, as much as possible. It pays to get in the habit of using async, because the problems with using sync-only code can be significant. Any long-running call to a sync-only function will block the entire call chain, making the benefits of using async all but evaporate.

If you're stuck using a long-running synchronous call for something, use asyncio.run_in_executor to farm out the call to a thread or process pool. A thread pool should be used whenever you’re waiting on an external event or a task that isn’t CPU-intensive. A process pool should be used for local tasks that are CPU-intensive.

For instance, if you have a route in your web application that makes a call to a remote website, you should use a thread—or, better yet, use the aiohttp library, which makes async HTTP requests. If you want to invoke the Pillow image library to resize an image, you probably should use run_in_executor with a process pool. Although there will be some slight overhead to shuttle data back and forth between processes, using run_in_executor will not block other events.


### How flask handles async with wsgi server 

pip install "Flask[async]"

```python

import asyncio

async def async_get_data():
    await asyncio.sleep(1)
    return 'Done!'


@app.route("/data")
async def get_data():
    data = await async_get_data()
    return data
```

Asyncio requires a event loop thread. It is created by doing asyncio.run in typical async app. In flask, this event loop is created in a new thread by flask when it processes any async route function. 


You can use any combination of async and sync route handlers in a Flask app without any performance hit. 

Keep in mind that even though asynchronous code can be executed in Flask, it's executed within the context of a synchronous framework. In other words, while you can execute various async tasks in a single request, each async task must finish before a response gets sent back. Therefore, there are limited situations where asynchronous routes will actually be beneficial. There are other Python web frameworks that support ASGI (Asynchronous Server Gateway Interface), which supports asynchronous call stacks so that routes can run concurrently:

https://testdriven.io/blog/flask-async/

### Does sqlachemy support async 
SQLAlchmey added async support in 1.4.0 release in March 2021.   
https://docs.sqlalchemy.org/en/14/orm/extensions/asyncio.html. 




