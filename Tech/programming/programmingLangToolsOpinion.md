for almost almost almost all Python use cases, threads should never be touched and asyncio/multiprocessing is the way to go instead. Most Python programs that need fast multi-threading instead should not have been written in Python.  

at large scale - you will eventually need to split computation across machines and will resort to in-memory cache/queue. If you have large concurrency and shared complex state - you better off use kafka and redis/memcached as a shared state - and design proper fan-out. However Stores like that, while scaling well, are orders of magnitudes slower than CPU memory.Soometimes you need all of that data in-process ... and io matters. eg. image processing or fancy algorithms.  

