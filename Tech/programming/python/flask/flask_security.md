Cookie Security:
https://blog.miguelgrinberg.com/post/cookie-security-for-flask-applications (2017)  


### XSS:  
https://flask.palletsprojects.com/en/2.0.x/security/#cross-site-scripting-xss  


### CSRF:  
https://flask.palletsprojects.com/en/2.0.x/security/#cross-site-request-forgery-csrf  


### Security Headers:  
https://flask.palletsprojects.com/en/2.0.x/security/#security-headers  

### Cookie Options
https://flask.palletsprojects.com/en/2.0.x/security/#set-cookie-options

### 2 Factor Auth
https://www.section.io/engineering-education/implementing-totp-2fa-using-flask/  


### Custom default error handler to stop server information being shown to user
from werkzeug.exceptions import HTTPException
https://flask.palletsprojects.com/en/2.2.x/errorhandling/

```python
@app.errorhandler(Exception)
def handle_exception(e):
    # pass through HTTP errors
    if isinstance(e, HTTPException):
        return e

    # now you're handling non-HTTP exceptions only
    return render_template("500_generic.html", e=e), 500
```

### escape all the user inputs
https://tedboy.github.io/flask/generated/flask.escape.html.    
escape(username).  

esure all the registered usernames are only a-z, 0-9 using username.alnum()

