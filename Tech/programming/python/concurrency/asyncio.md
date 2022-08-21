

### Mixing asynch and synch

You absolutely can call non-async code from async-code, in fact it’s easy to do so. But if a method/function call might “block” (ie. take a long time before it returns) then you really shouldn’t.  The non-async code  “blocks the event loop” for as long as it runs.  

The python standard libary and most packages as synch. If underlying libraries are doing synchronous IO/operations and then entire code is not asych any more  
https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-5.html  

THis issue is overcome with 
- having thread pool (Even though pure asyncio is single threaded technology)
- In fact it’s very useful to have a pool of threads available so that you can submit long-running blocking work to them and allow those long-running blocking calls to each occupy a thread of their own whilst they run.
  - asyncio provides run_in_executor whose first argument is a threadpool

GIL issue  
Global Interpreter Lock is a mutex which is always held by any thread that is currently interpreting Python instructions within a single process. As a result it’s usually not possible for two Python threads to be actually running python code simultaneously, though they can switch back and forth as often as between individual instructions.

- if a Python method calls out to native code for some purpose then it will release the GIL before doing so. Hence multiple threads can be running simultaneously if all but one of them are currently running native code.
  - almost all blocking IO code in Python actually calls out to native code during its blocking period
  - If CPU bound code is written in pure python then it can hold the GIL . In this case asyncio provides option use multiprocessing
    - You can construct an object of class concurrent.futures.ProcessPoolExecutor and pass it as the first parameter of run_in_executor, instead of None. This will cause your code to be run not in another thread, but in another process entirely, and thus the GIL will not be shared.  
  
https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-5.html#executors-and-multithreading  
https://bbc.github.io/cloudfit-public-docs/asyncio/asyncio-part-5.html#what-about-the-global-interpreter-lock  


