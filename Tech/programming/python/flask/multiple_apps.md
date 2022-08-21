### Application Dispatching

If you have entirely separated applications and you want them to work next to each other in the same Python interpreter process you can take advantage of the werkzeug.wsgi.DispatcherMiddleware. The idea here is that each Flask application is a valid WSGI application and they are combined by the dispatcher middleware into a larger one that is dispatched based on prefix.

For example you could have your main application run on / and your backend interface on /backend:
```python
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from frontend_app import application as frontend
from backend_app import application as backend

application = DispatcherMiddleware(frontend, {
    '/backend': backend
})
```
Use multiple instances of the same application with different configurations. Example would be creating applications per subdomain for each user  
https://flask.palletsprojects.com/en/2.0.x/patterns/appdispatch/#dispatch-by-subdomain  



