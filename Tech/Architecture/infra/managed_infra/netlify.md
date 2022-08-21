I am hosting the frontend of my application and doing auth using Netlify, I want to store some additional user information in my own database and make calls to an API I have built and I need to verify the user is who they say they are, how do I do this.   

### Go True API endpoints
GoTrue is a small open-source API written in Golang, that can act as a self-standing API service for handling user registration and authentication for Jamstack projects.   
https://github.com/netlify/gotrue#endpoints.  

You can verify the signature of our JWT’s in a Netlify function. In fact if you pass an Identity JWT in as a bearer token in an Authorization header, we’ll verify for you automatically and inject the user data in to the functions context. From there you can actually run some logic with that data or sign a new JWT and send it to your own backend. Another option is to use JWS with netlify redirects so that you can confirm that the request comes Netlify directly. 


### Netlify signed proxy redirects
https://www.netlify.com/blog/2017/10/17/introducing-structured-redirects-and-headers/#signed-proxy-redirects. 

Testing out netlify redirect with pastebin   
https://answers.netlify.com/t/cant-find-jws-signature-for-signed-proxy-redirect/38992/12


**JWT and JWS**.  
JWT (JSON Web Token) is a way of representing claims which are name-value pairs into a JSON object. JWT spec defines a set of standard claims to be used or transferred between two parties.

On the other hand, JWS (JSON Web Signature) is a mechanism for transferring JWT payload between two parties with guarantee for Integrity. JWS spec defines multiple ways of signing (eg. HMAC or digital signature) the payload and multiple ways of serializing the content to transfer across network.


redirect rules are in netlify.toml in site config.  

redirecting to backend API.  
```bash
[[redirects]]
  from = "/api"
  to = "https://my-api.example.com"
  status = 200
  force = true
  headers = {X-From = "netlify", X-Custom-Token = "my custom token"}
```

To give you more confidence about the origin of requests that arrive to a proxied server, Netlify has added the keyword signed so you can sign all proxy requests with a JSON Web Signature (JWS). To enable JWS on your requests Netlify requires a secret token. You can set that token in your site’s environment, and reference it in the redirect rule.  

```bash
[[redirects]]
  from = "/api"
  to = "https://my-api.example.com"
  status = 200
  force = true
  signed = "NAME_OF_MY_ENVIRONMENT_VARIABLE". 
```  


 you have a few options, one of them is to use signed proxy redirects, you can read about this at https://www.netlify.com/blog/2017/10/17/introducing-structured-redirects-and-headers/#signed-proxy-redirects 15 . And you proxy the api call to your backend and you send the request through that proxy and we’ll sign it with a JWT that you can now authenticate since you’ll have the signing secret. Another option is to use a library to generate a JWT in your function that you send to your backend and authenticate there. Either way will be fine.
 
 ### Protecting netlify functions from external access
 https://answers.netlify.com/t/signed-proxy-redirects/17688/4    
 
 
  I am trying to limit my netlify functions to my own netlify site.    
  Can signed proxy redirects be used for this purpose? I created an endpoint with requestbin.com and set my to destination in my netlify.toml file to that endpoint.   
  Then I hit my /api/ with Postman and checked the logs on Request Bin and the requests contained the correct x-nf-sign header, even though the traffic came from Postman not Netlify. So it seems signed proxy redirects do not actually ensure our Netlify functions are called by Netlify.   
  

### Using User identity to protect netlify function

1) For site with no login users
https://answers.netlify.com/t/signed-proxy-redirects/17688/6  
I have a solution that might be useful (I use it currently). You could use Netlify Identity and create a random user with a random email and password. Then, you could pass that user using the Authorisation header to your functions. Inside the functions, you could verify if that Auth token is valid valid user of your website and authorise the function accordingly. To further increase the security, I delete the user inside the function so that no one can exploit the Auth token. It’s not fool-proof (I can explain why if needed), but does add a robust security mechanism.   



If this sounds like a workable solution, I can provide you with an example of how I do it. It’s not super practical probably, but gets the job done.

2) For sites with users, where function are triggered by user actions

 https://answers.netlify.com/t/netlify-identity-and-go-functions/17810   
Is the Bearer token the frontend provides just forwarded along to the backend via the context (with no intermediate steps)?   
Answer:   
Yea. You provide the token and our system will do the checks. If it’s valid, you will find the claims in the context.clientContext.user object. So you could check for that object to confirm that the request is authorized.    
