
`SSR`: Server side rendering. Uses sveltkit endpoints

`CSR and SPA`: Client side rendering and single page application.  
- SPA has single html
- has client side routing which handles the navigation on clicks etc
- page common layout remain unchanged. Only the contents gets updated. 
Not good for SEO. Preferred for Login based apps.  


`Prerendering`: build and prepare the html of the page   

`SSG`: static site generation where each page of site is pre rendered. 
adapter-static adaptor does this.  

Hydration:   

`Routing`: Instead of browser navigating to another page on click, svelte will handle the navaigation, and call the necesarry endpoints

https://kit.svelte.dev/docs/appendix


### deploy the svelte-kit app as a static page, and then making direct requests to your python based service.
 This is CSR and SPA approach and let the flask backend handle API calls. 
 

### Proper way to do Sveltekit with same domain backend?

Using svelte endpoint. 

the flow to login is basically:  
Client loads app and navigates to login page. 
Client sends login info to svelte endpoint. 
Endpoint sends info to API (flask app on same domain). 
API verifies and returns details to svelte server. 
Svelte creates session (cookie-based) and returns verification to user.  
This leaves us open to CSRF attacks so I plan to add a csrf token. I have CSRF protect on the flask app. That should be routed through an endpoint to the client,   