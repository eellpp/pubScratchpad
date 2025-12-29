No, g is not an object to hang session data on. g data is not persisted between requests.  
A common use for g is to manage resources during a request.  

session gives you a place to store data per specific browser. As a user of your Flask app, using a specific browser, returns for more requests, the session data is carried over across those requests.

g on the other hand is data shared between different parts of your code base within one request cycle. g can be set up during before_request hooks, is still available during the teardown_request phase and once the request is done and sent out to the client, g is cleared.  

The advantage of g is that it exists across all of your request, is thread safe, and specific to your current app (if you were to nest Flask apps where one calls another this becomes important). So you can set a user object or database connection with a before_request hook, then access that same user or connection in your templates, and still have available in a teardown hook without having to pass it along to each call.  
