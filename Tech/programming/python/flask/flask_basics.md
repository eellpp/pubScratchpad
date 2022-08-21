
### Web Server and Application server
A production setup usually consists of multiple components, each designed and built to be really good at one specific thing. They are fast, reliable and very focused.

Communication with the whole thing, as in the case of the built-in web server, happens via HTTP. A request comes in and arrives at the first component - a dedicated web server. It is great at reading static files from disk (your css files for example) and handling multiple requests. When a request is not a static file, but meant for your all it gets passed on down the stack.

The application server gets those fancy requests and converts the information from them into Python objects which are usable by frameworks

### Flask dev only web server
It is only meant to be used by one person at a time, and is built this way. It can also serve static files, but does so very slowly compared to tools which are built to do it quickly.  

### Flask Prod Setup
If you want to run Flask in production, be sure to use a production-ready web server like Nginx, and let your app be handled by a WSGI application server like Gunicorn.  
Your Flask app does not actually run as you would think a server would - waiting for requests and reacting to them. In this setup, it can be seen as a function which is called by the application server, being provided the request object  

If you plan on running on Google cloud functions/heroku, a web server is provided implicitly. You just need to specify a command to run the application server (again, Gunicorn is fine) in the Procfile. 

Ref: https://vsupalov.com/flask-web-server-in-production/  

