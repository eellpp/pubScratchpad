https://portswigger.net/web-security/cross-site-scripting  

XSS (Cross site scripting) attack can be 

1) Reflected XSS, where the malicious script comes from the current HTTP request.
2) Stored XSS, where the malicious script comes from the website's database.
3) DOM-based XSS, where the vulnerability exists in client-side code rather than server-side code.


### Stored (Most Dangerous)
Instead of text content (eg: address) in input box, attacker places a script. The data gets stored in backend in user profile. When  a customer support views the information on his browser, the script gets executed in his browser and do malicious activities  

### Reflected (Most prevalent)
Here the URL params (or hidden fields in page form) contains malicious script for a legitimate websites. This URL link (with malicious script in url params/post data) is shared by attacker over email etc. Users check the domain name is correct on the script and click on it. However, since this XSS vulnerability on the website is getting exploited, the attackers script executes in user browser and can cause unintended actions  

```bash
Here is a simple example of a reflected XSS vulnerability:

https://insecure-website.com/status?message=All+is+well.

<p>Status: All is well.</p>

The application doesn't perform any other processing of the data, so an attacker can easily construct an attack like this:

https://insecure-website.com/status?message=<script>/*+Bad+stuff+here...+*/</script>

<p>Status: <script>/* Bad stuff here... */</script></p>

If the user visits the URL constructed by the attacker, then the attacker's script executes in the user's browser, in the context of that user's session with the application. At that point, the script can carry out any action, and retrieve any data, to which the user has access.
```

### Dom Based 
Similar to reflected with only difference that the request never hits the server.  
This is applicable for the javascript frameworks which loads the page elements without full page refresh.  
Instead of url query params (as in reflected: xx.com/page?name="" ), here the input is from the page fragment (xx.com/page#name)   

DOM-based XSS is a significant threat in modern JavaScript-based frontends, especially when they rely on third-party libraries and components. So can we use Trusted Types to mitigate these XSS attack vectors?

The short answer is: yes, absolutely!.

The longer answer is more along the lines of: yes, if you follow a couple of coding guidelines.

https://auth0.com/blog/securing-spa-with-trusted-types/  


### Two Primary methods of protection
1) `Input validation`: All the input data from client should be validated in server. Eg date should be of valid date type. Name should have only string etc ..   
Do not accept HTML rich text input from user. Use markup languages and their associated escaping.      
2) `Output Escaping` : Use URL escaping if param appears in URL, or output encoding if it is displayed on the page.  

Eg:  using &amp => & , &lt => < etc . This is will correctly displayed by browser and not executed even if malicious content is placed.  
All the form values (even if hidden), need to be encoded when output on broswer.   

How to prevent   
- Sanitize data input in an HTTP request before reflecting it back, ensuring all data is validated, filtered or escaped before echoing anything back to the user, such as the values of query parameters during searches.
- Convert special characters such as ?, &, /, <, > and spaces to their respective HTML or URL encoded equivalents.
- Give users the option to disable client-side scripts.
- Redirect invalid requests.
- Detect simultaneous logins, including those from two separate IP addresses, and invalidate those sessions.
- Use and enforce a Content Security Policy (source: Wikipedia) to disable any features that might be manipulated for an XSS attack.
- Read the documentation for any of the libraries referenced in your code to understand which elements allow for embedded HTML.

On client side use javascript input encoders and validators 

### OWASP XSS protection cheat sheet
https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html  


### How to find and test for XSS vulnerabilities
The vast majority of XSS vulnerabilities can be found quickly and reliably using Burp Suite's web vulnerability scanner.

Manually testing for reflected and stored XSS normally involves 
1) submitting some simple unique input (such as a short alphanumeric string) into every entry point in the application, 
2) identifying every location where the submitted input is returned in HTTP responses, and 
3) testing each location individually to determine whether suitably crafted input can be used to execute arbitrary JavaScript. 
In this way, you can determine the context in which the XSS occurs and select a suitable payload to exploit it.

Manually testing for DOM-based XSS arising from URL parameters involves a similar process: 
1) placing some simple unique input in the parameter, using the browser's developer tools to search the DOM for this input, and 
2) testing each location to determine whether it is exploitable. However, other types of DOM XSS are harder to detect. 

To find DOM-based vulnerabilities in non-URL-based input (such as document.cookie) or non-HTML-based sinks (like setTimeout), there is no substitute for reviewing JavaScript code, which can be extremely time-consuming. 

Burp Suite's web vulnerability scanner combines static and dynamic analysis of JavaScript to reliably automate the detection of DOM-based vulnerabilities.


### Using CSP 
Content Security Policy (CSP)  
CSP is a header that allows developers to restrict valid sources of executable scripts, AJAX requests, images, fonts, stylesheets, form actions, etc.  

https://michaelzanggl.com/articles/web-security-xss/  

Examples: 
only allow scripts from your own site, block javascript: URLs, inline event handlers, inline scripts and inline styles  
`Content-Security-Policy: default-src 'self' ` 
only allow AJAX requests to your own site and api.example.com  
`Content-Security-Policy: connect-src 'self' https://api.example.com;`  
allow images from anywhere, audio/video from media1.com and any subdomains from media2.com, and scripts from userscripts.example.com  
`Content-Security-Policy: default-src 'self'; img-src *; media-src media1.com *.media2.com; script-src userscripts.example.com`  
These are just some examples, CSP has a lot of other features like sending reports on violations. Be sure to read more on it here.  

It's important to not only rely on CSPs. This is the last resort in case your site is indeed vulnerable to XSS attacks. Please still follow the other recommendations.  


### React/Svelte XSS protection
https://lolware.net/blog/react-xss-protection-cheat-sheet/   
https://github.com/sveltejs/svelte/issues/6423  
https://www.freecodecamp.org/news/best-practices-for-security-of-your-react-js-application/  


### Javascript ESAPI security
https://owasp.org/www-pdf-archive/ESAPI4JS-Marcus.Niemietz.pdf  
The target is that a developer without a broad security knowledge should write secure applications. This is exactly what this paper is about. A community of security-experienced people is developing an interface to offer possibilities for security and lower-risk applications by ready-made methods. This paper analyses the JavaScript-based ESAPI as such a tool. It is presented in general and each given assurance criteria is discussed for security reasons. After that improvements on general objectives, redundancy aspects, and old as well as newly defined methods are shown. The paper concludes with an outlook about how the ESAPI affects itself and the future.    

### Libraries
https://github.com/cure53/DOMPurify  

