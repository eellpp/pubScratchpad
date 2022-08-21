In the session based authentication, the server will create a session for the user after the user logs in. The session id is then stored on a cookie on the user’s browser. While the user stays logged in, the cookie would be sent along with every subsequent request. The server can then compare the session id stored on the cookie against the session information stored in the memory to verify user’s identity and sends response with the corresponding state!  

Scalability  
Because the sessions are stored in the server’s memory, scaling becomes an issue when there is a huge number of users using the system at once    

Multiple Devices  
Cookies normally work on a single domain or subdomains and they are normally disabled by browser if they work cross-domain (3rd party cookies). It poses issues when APIs are served from a different domain to mobile and web devices.  


Sessions act as a means to store simple pieces of data against a session ID, while the webapp container manages the storage of these and relates them to the session ID.

Typically these IDs are transmitted by cookies  
The container will also handle the session’s entire lifecycle, including expiring it when it’s no longer needed. Often this is tied not to a specific point in time, but rather to a period of inactivity. This means that the user remains authenticated only for as long as they are actively using the system, and once they finish, the session will expire and they will no longer be authenticated.  



https://sherryhsu.medium.com/session-vs-token-based-authentication-11a6c5ac45e4  

