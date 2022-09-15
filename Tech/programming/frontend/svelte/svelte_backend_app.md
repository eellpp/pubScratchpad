
### deploy the svelte-kit app as a static page, and then making direct requests to your python based service.


### Proper way to do Sveltekit with same domain backend?

Using svelte endpoint. 

the flow to login is basically:  
Client loads app and navigates to login page. 
Client sends login info to svelte endpoint. 
Endpoint sends info to API (flask app on same domain). 
API verifies and returns details to svelte server. 
Svelte creates session (cookie-based) and returns verification to user.  
This leaves us open to CSRF attacks so I plan to add a csrf token. I have CSRF protect on the flask app. That should be routed through an endpoint to the client,   