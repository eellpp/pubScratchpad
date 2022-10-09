https://docs.python.org/3/library/asyncio-task.html

### Diffrence between gather and create task
asyncio.gather() runs create_task internally to create tasks and ensures that the calling coroutine awaits till all of them completes

### Will gather cancel all the coroutine if one of the coroutine causes exception
No  
gather is just a helper to wait for them to finish. For this reason gather doesn't bother to cancel the remaining tasks if some of them fails with an exception - it just abandons the wait and propagates the exception, leaving the remaining tasks to proceed in the background.  

https://stackoverflow.com/a/59074112. 





