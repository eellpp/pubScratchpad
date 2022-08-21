https://alexkrupp.typepad.com/sensemaking/2021/06/django-for-startup-founders-a-better-software-architecture-for-saas-startups-and-consumer-apps.html  

```bash
Predictability
Rule #1: Every endpoint should tell a story
Rule #2: Keep business logic in services
Rule #3: Make services the locus of reusability
Rule #4: Always sanitize user input, sometimes save raw input, always escape output
Rule #5: Don't split files by default & never split your URLs file
Readability
Rule #6: Each variable's type or kind should be obvious from its name
Rule #7: Assign unique names to files, classes, and functions
Rule #8: Avoid *args and **kwargs in user code
Rule #9: Use functions, not classes
Rule #10: There are exactly 4 types of errors
Simplicity
Rule #11: URL parameters are a scam
Rule #12: Write tests. Not too many. Mostly integration.
Rule #13: Treat unit tests as a specialist tool
Rule #14: Use serializers responsibly, or not at all
Rule #15: Write admin functionality as API endpoints
Upgradability
Rule #16: Your app lives until your dependencies die
Rule #17: Keep logic out of the front end
Rule #18: Don't break core dependencies
Why make coding easier?
Velocity
Optionality
Security
Diversity
```
