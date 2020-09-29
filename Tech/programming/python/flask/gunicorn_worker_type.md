Gunicorn provides serval types of worker: sync, gthread, gevent, evenlet, tornado … and it can be clarified into three different categories:  

1) `request per process (sync)`: master process delegates a single http request to a worker at a time.  
2) `request per thread (gthread)`: each worker process spawns a number of threads, gunicorn delegates a single http request to a thread spawned by a worker at a time.  
3) `request with async IO (gevent, evenlet or tornado)`: a worker process handles multiple requests at a time with async IO.  

For CPU bounded apps, you can go with “request per process” or “request per thread”. For I/O bounded apps , it is recommended to use coroutines.
If you don’t know what you are doing, you can start with “request per process” option, then enhance the source code to be thread-safe and change to “request per thread” for higher number of concurrent requests. If the thread does not solve your problem, go ahead and implement connection pool and monkey patch your code to use coroutines approach.

https://medium.com/@nhudinhtuan/gunicorn-worker-types-practice-advice-for-better-performance-7a299bb8f929
