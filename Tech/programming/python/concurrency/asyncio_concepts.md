
### Concurrency vs threading vs multiprocessing
multiprocessing is ideal for CPU-bound tasks and threading is suited for IO-bound tasks. 

Concurrency suggests that multiple tasks have the ability to run in an overlapping manner. (There’s a saying that concurrency does not imply parallelism.

A process can have multiple threads and those threads can run concurrently in overlapping manner in if none of the threads are cpu bound. If the thread calls IO calls (most python internal io calls are native calls and release gil lock) then other threads get a chance to execute. 

https://realpython.com/async-io-python/

### Mixing asynch and synch

You absolutely can call non-async code from async-code, in fact it’s easy to do so. But if a method/function call might “block” (ie. take a long time before it returns) then you really shouldn’t.  The non-async code  “blocks the event loop” for as long as it runs.  

The python standard libary and most packages as synch. If underlying libraries are doing synchronous IO/operations and then entire code is not asych any more  
https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-5.html  

THis issue is overcome with 
- having thread pool (Even though pure asyncio is single threaded technology)
- In fact it’s very useful to have a pool of threads available so that you can submit long-running blocking work to them and allow those long-running blocking calls to each occupy a thread of their own whilst they run.
  - asyncio provides run_in_executor whose first argument is a threadpool

### If python has GIL , how it can do concurrency in threads for io bound operations
GIL issue  
Global Interpreter Lock is a mutex which is always held by any thread that is currently interpreting Python instructions within a single process. As a result it’s usually not possible for two Python threads to be actually running python code simultaneously, though they can switch back and forth as often as between individual instructions.

- if a Python method calls out to native code for some purpose then it will release the GIL before doing so. Hence multiple threads can be running simultaneously if all but one of them are currently running native code.
  - almost all blocking IO code in Python actually calls out to native code during its blocking period
  - If CPU bound code is written in pure python then it can hold the GIL . In this case asyncio provides option use multiprocessing
    - You can construct an object of class concurrent.futures.ProcessPoolExecutor and pass it as the first parameter of run_in_executor, instead of None. This will cause your code to be run not in another thread, but in another process entirely, and thus the GIL will not be shared.  
  
https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-5.html#executors-and-multithreading  
https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-5.html#what-about-the-global-interpreter-lock  


### How gunicorn can handle thousands of concurrent requests
with 5 worker processes, each with 8 threads, 40 concurrent requests can be served
Requests per second is not the same as "concurrent requests".

If each request takes exactly 1 millisecond to handle, then a single worker can serve 1000 RPS. If each request takes 10 milliseconds, a single worker dishes out 100 RPS.

If some requests take 10 milliseconds, others take, say, up to 5 seconds, then you'll need more than one concurrent worker, so the one request that takes 5 seconds does not "hog" all of your serving capability.

### Does requests module get/post request release GIL lock and take advantage of threading to call multiple requests simulataneously

For I/O bound tasks (like downloading webpages), the GIL is not a problem. 

If you have 4 threads, then 4 requests can be handled simultaneously. Os does premptible scheduling on threads for IO bound operations.  
Python releases the GIL when I/O is happening, which means all the threads will be able execute the requests in parallel. Whenever you're doing processing of the downloaded pages, this is where the GIL can hurt you.

### AsychIO
cooperative multitasking inloves communication with multiple tasks to let each take turns running at the optimal time. To achieve concurrancy with single thread, it uses event loop. Event loops run asynchronous tasks and callbacks, perform network IO operations, and run subprocesses.


At the heart of async IO are coroutines.  
When you add the async keyword to the function, the function becomes a coroutine.  
A coroutine is a regular function with the ability to pause its execution when encountering an operation that may take a while to complete.  
- await keyword pauses the execution of the function
- async keyword makes the function a coroutine 


 a coroutine is a function that can suspend its execution before reaching return, and it can indirectly pass control to another coroutine for some time. (works like a generator function with yield)

### what happens when you use requests.get in a async function 
Inside a async function if you use requests.get and this request is stuck for 100 sec, then the entire event loop is stuck and not other co-routines can run. Instead of requests.get, you need to use aiohttp which is a request package designed to be used with asyncio.   
Similarly if in async function if there code that is doing cpu intensive work, then it will block all other co-routines


### What will asych function return if you dont await on it 
It returns an awaitable and the function is not executed. It is only schduled for execution on eventloop when await is called. 


 ### When to use and not use await 
https://stackoverflow.com/a/33399896


 By default all your code is synchronous. You can make it asynchronous defining functions with async def and "calling" these functions with await. A More correct question would be "When should I write asynchronous code instead of synchronous?". Answer is "When you can benefit from it". In cases when you work with I/O operations as you noted you will usually benefit:   

# Synchronous way:
```python
download(url1)  # takes 5 sec.
download(url2)  # takes 5 sec.
```
# Total time: 10 sec.

# Asynchronous way:
```python
await asyncio.gather(
    async_download(url1),  # takes 5 sec. 
    async_download(url2)   # takes 5 sec.
)
```
# Total time: only 5 sec. (+ little overhead for using asyncio). 
Of course, if you created a function that uses asynchronous code, this function should be asynchronous too (should be defined as async def). But any asynchronous function can freely use synchronous code. It makes no sense to cast synchronous code to asynchronous without some reason:  

# extract_links(url) should be async because it uses async func async_download() inside. 
```python
async def extract_links(url):  

    # async_download() was created async to get benefit of I/O
    html = await async_download(url)  

    # parse() doesn't work with I/O, there's no sense to make it async
    links = parse(html)  

    return links
```.  

One very important thing is that any long synchronous operation (> 50 ms, for example, it's hard to say exactly) will freeze all your asynchronous operations for that time:
```python
async def extract_links(url):
    data = await download(url)
    links = parse(data)
    # if search_in_very_big_file() takes much time to process,
    # all your running async funcs (somewhere else in code) will be frozen
    # you need to avoid this situation
    links_found = search_in_very_big_file(links)
```

You can avoid it calling long running synchronous functions in separate process (and awaiting for result):

```python
executor = ProcessPoolExecutor(2)

async def extract_links(url):
    data = await download(url)
    links = parse(data)
    # Now your main process can handle another async functions while separate process running    
    links_found = await loop.run_in_executor(executor, search_in_very_big_file, links)
```

One more example: when you need to use requests in asyncio. requests.get is just synchronous long running function, which you shouldn't call inside async code (again, to avoid freezing). But it's running long because of I/O, not because of long calculations. In that case, you can use ThreadPoolExecutor instead of ProcessPoolExecutor to avoid some multiprocessing overhead:

```python
executor = ThreadPoolExecutor(2)

async def download(url):
    response = await loop.run_in_executor(executor, requests.get, url)
    return response.text

```


### How is javascript asynch await different from python
In js, the event loop is running by default. In python we have manually start it by asychio.run()   
https://stackoverflow.com/questions/68139555/difference-between-async-await-in-python-vs-javascript. 

js event loop has functions that would be executed completly unless awaited (in which case it would added again to event loop).   
In python model, when await is encountered it will suspend the execution of function (release resources) and allow other functions to continue 

### How eventloop execution is different form thread.  
Threads are scheduled by OS. It will prempt the thread execution if its blocking on any IO bound task.  
Event loop runs in its own thread and coroutine scheduling algo 


### what is the scheduling algo for event loop in python
Unless otherwise specified in documentation, concrete algorithm is a detail of implementation and can be changed between asyncio versions. You shouldn't rely on it.
Different event loop can implement different algorithms. While all asyncio's loops seems to use one in BaseEventLoop, other event loops like custom uvloop may do something different.
https://stackoverflow.com/a/59321485.  



