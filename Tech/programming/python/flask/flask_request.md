1. Before each request, `before_request()` functions are called. If one of these functions return a value, the other functions are skipped. The return value is treated as the response and the view function is not called.
2. If the before_request() functions did not return a response, the view function for the matched route is called and returns a response.
3. The return value of the view is converted into an actual response object and passed to the `after_request()` functions. Each function returns a modified or new response object.
4. After the response is returned, the contexts are popped, which calls the `teardown_request()` and `teardown_appcontext()` functions. These functions are called even if an unhandled exception was raised at any point above.


Flask provides two contexts:

1. Application Context.
2. Request Context.

The Application context is used to store values which are generic to the application like database connection, configurations etc; whereas Request context is used to store values that are specific to each request

When a Flask application begins handling a request, it pushes a request context, which also pushes an The Application Context. When the request ends it pops the request context then the application context.  

### Application Context
The application context is a good place to store common data during a request or CLI command. Flask provides the g object for this purpose. It is a simple namespace object that has the same lifetime as an application context.  
https://flask.palletsprojects.com/en/1.1.x/appcontext/  

Example: Opening a db connection, using it and closing at end of request

```python
from flask import g

def get_db():
    if 'db' not in g:
        g.db = connect_to_database()

    return g.db

@app.teardown_appcontext
def teardown_db():
    db = g.pop('db', None)

    if db is not None:
        db.close()
```

### Request Context
The request context keeps track of the request-level data during a request. Rather than passing the request object to each function that runs during a request, the request and session proxies are accessed instead.  
The request object contains the information about the current web request and session is a dictionary-like object that is used to store values that persists between requests.

https://flask.palletsprojects.com/en/1.1.x/reqcontext/   

eg: getting request args  
format = request.args.get('format')  

When the request starts, a RequestContext is created and pushed, which creates and pushes an AppContext first if a context for that application is not already the top context. While these contexts are pushed, the current_app, g, request, and session proxies are available to the original thread handling the request.

After the request is dispatched and a response is generated and sent, the request context is popped, which then pops the application context. Immediately before they are popped, the teardown_request() and teardown_appcontext() functions are executed. These execute even if an unhandled exception occurred during dispatch.  

If an exception is raised before the teardown functions, Flask tries to match it with an errorhandler() function to handle the exception and return a response. If no error handler is found, or the handler itself raises an exception, Flask returns a generic 500 Internal Server Error response. The teardown functions are still called, and are passed the exception object.  

From flask 1.1.0 version, after_request functions and other finalization is done even for the default 500 response when there is no handler.  

https://flask.palletsprojects.com/en/1.1.x/api/  

