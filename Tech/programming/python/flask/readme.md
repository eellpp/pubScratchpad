## Prod Setup
`Web server`: It is great at reading static files from disk (your css files for example) and handling multiple requests.  Eg WSGI Server/Gateway like Apache or Nginx.
If you plan on running on Google cloud functions/heroku, a web server is provided implicitly.  

`Application server`:  Gunicorn 'Green Unicorn' is a Python WSGI HTTP Server for UNIX
Your Flask app can be seen as a function which is called by the application server, being provided the request object

WSGI is a Web Server Gateway Interface, a specification that explains how a web server communicates with web applications, and how the applications can be chained together to generate requests.  
It is the Web server that triggers the web app, and transmits related information, with a callback function to the app. The processing of the request takes place on the app side, while the web server receives the response, by making use of the callback function.  

There could be more than one WSGI middleware between the web app and the server. Their function would be to direct requests to various app objects, content preprocessing, load balancing, and so on.  


## Flask Request
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/python/flask/flask_request.md  

Flask provides two contexts:

Application Context.  
Request Context.  

### Application Context
The application context keeps track of the application-level data during a request, CLI command, or other activity. Rather than passing the application around to each function, the current_app and g proxies are accessed instead.  
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/python/flask/flask_request.md#application-context

### Request Context
The request context keeps track of the request-level data during a request. Rather than passing the request object to each function that runs during a request, the request and session proxies are accessed instead.  
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/python/flask/flask_request.md#request-context  


## Gunicor
Worker Types  
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/python/flask/gunicorn_worker_type.md
