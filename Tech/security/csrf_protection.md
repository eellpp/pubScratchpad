https://owasp.org/www-community/attacks/csrf  
### How does the attack work?
There are numerous ways in which an end user can be tricked into loading information from or submitting information to a web application. In order to execute an attack, we must first understand how to generate a valid malicious request for our victim to execute. Let us consider the following example: Alice wishes to transfer $100 to Bob using the bank.com web application that is vulnerable to CSRF. Maria, an attacker, wants to trick Alice into sending the money to Maria instead. The attack will comprise the following steps:

Building an exploit URL or script  
Tricking Alice into executing the action with Social Engineering

https://owasp.org/www-project-code-review-guide/reviewing-code-for-csrf-issues  

### Good Patterns and procedures to prevent CSRF  

Checking if the request has a valid session cookie is not enough, we need check if a unique identifier is sent with every HTTP request sent to the application. CSRF requests WON’T have this valid unique identifier. The reason CSRF requests won’t have this unique request identifier is the unique ID is rendered as a hidden field on the page and is appended to the HTTP request once a link/button press is selected. The attacker will have no knowledge of this unique ID, as it is random and rendered dynamically per link, per page.  

1. A list is complied prior to delivering the page to the user. The list contains all valid unique IDs generated for all links on a given page. The unique ID could be derived from a secure random generator such as SecureRandom for J2EE. .  
2. A unique ID is appended to each link/form on the requested page prior to being displayed to the user.
3. Maintaining a list of unique IDs in the user session, the application checks if the unique ID passed with the HTTP request is valid for a given request. if the unique ID passed with the HTTP request is valid for a given request.
4. If the unique ID is not present, terminate the user session and display an error to the user.

### User Interaction
Upon committing to a transaction, such as fund transfer, display an additional decision to the user, such as a requirement for one’s password to be entered and verified prior to the transaction taking place. A CSRF attacker would not know the password of the user and therefore the transaction could not be committed via a stealth CSRF attack.

### CORS and CSRF
https://github.com/eellpp/pubScratchpad/blob/master/Tech/programming/frontend/concepts/CORS.md  
