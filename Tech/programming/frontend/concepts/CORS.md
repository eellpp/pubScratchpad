
Modern browsers use CORS in APIs such as XMLHttpRequest or Fetch to mitigate the risks of cross-origin HTTP requests.

### CORS is a preflight request  

A preflight request is a small request that is sent by the browser before the actual request. It contains information like which HTTP method is used, as well as if any custom HTTP headers are present. The preflight gives the server a chance to examine what the actual request will look like before it's made.


A GET/POST requests without any custom headers don't need a preflight, since these requests were already possible before CORS.  
But any request with custom headers, or PUT/DELETE requests, do need a preflight, since these are new to the CORS spec. If the server knows nothing about CORS, it will reply without any CORS-specific headers, and the actual request will not be made.  

The preflight mechanism benefits servers that were developed without an awareness of CORS, and it functions as a sanity check between the client and the server that they are both CORS-aware.  

New servers that are written with an awareness of CORS. According to standard security practices, the server has to protect its resources in the face of any incoming request -- servers can't trust clients to not do malicious things. This scenario doesn't benefit from the preflight mechanism: the preflight mechanism brings no additional security to a server that has properly protected its resources.

### Example:
Let's imagine that a browser user is logged into their banking site at A.com. When they navigate to the malicious B.com, that page includes some Javascript that tries to send a DELETE request to A.com/account. Since the user is logged into A.com, that request, if sent, would include cookies that identify the user.

Before CORS, the browser's Same Origin Policy would have blocked it from sending this request. But since the purpose of CORS is to make just this kind of cross-origin communication possible, that's no longer appropriate.

The browser could simply send the DELETE and let the server decide how to handle it. But what if A.com isn't aware of the CORS protocol? It might go ahead and execute the dangerous DELETE. It might have assumed that—due to the browser's Same Origin Policy—it could never receive such a request, and thus it might have never been hardened against such an attack.

To protect such non-CORS-aware servers, then, the protocol requires the browser to first send a preflight request. This new kind of request is something that only CORS-aware servers can respond to properly, allowing the browser to know whether or not it's safe to send the actual DELETE.

Why all this fuss about the browser, can't the attacker just send a DELETE request from their own computer?   
Sure, but such a request won't include the user's cookies. The attack that this is designed to prevent relies on the fact that the browser will send cookies (in particular, authentication information for the user) for the other domain along with the request.  

But POST is listed as a method that doesn't require preflights. That can change state and delete data just like a DELETE!  
That's true! CORS does not protect your site from CSRF attacks. Then again, without CORS you are also not protected from CSRF attacks. The purpose of preflight requests is just to limit your CSRF exposure to what already existed in the pre-CORS world.  

https://stackoverflow.com/questions/15381105/what-is-the-motivation-behind-the-introduction-of-preflight-cors-requests

### MDN definition
A CORS preflight request is a CORS request that checks to see if the CORS protocol is understood and a server is aware using specific methods and headers.  

### What triggers CORS preflight request from browser
Any differences in the page's hostname, port, and protocol and a request executed on the page will require a CORS request.   
Eg: 
You're working on a site, foobarbaz.app, and you've deployed your API to a subdomain at api.foobarbaz.app.  
API at api.foobarbaz.app is not of the same origin as foobarbaz.app, specifically the hostname is now different. Port (:443, :80, etc) and protocol (HTTP, HTTPS) also follow the same logic as hostname.  
This will trigger a preflight request  

https://nickolinger.com/blog/2021-08-04-you-dont-need-that-cors-request/




https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS  

An example of a cross-origin request: the front-end JavaScript code served from https://domain-a.com uses XMLHttpRequest to make a request for https://domain-b.com/data.json  

