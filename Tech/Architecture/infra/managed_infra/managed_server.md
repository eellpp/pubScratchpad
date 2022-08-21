### Hetzner Managed server 

https://news.ycombinator.com/item?id=22250535.  

Do note that with dedicated servers you are subjecting yourself to things such as hardware upgrades and failures which you will have to manage yourself if you want to prevent downtime.   
And while Hetzner customer support is generally excellent, in my experience, their handling of DDoS incidents will generally leave your server blackholed and sometimes requires manual intervention to get back online.    
This is something you need to account for in terms of redundance if you are planning to expose your application directly to the net without any CDN/Load balancer/DDoS filter in place.   
From my experience it makes sense to work with a data centre that is less focussed on a mass market but allows for individual client relations to mitigate risks like that. I love Hetzner for what they are and do host some services with them, but I wouldn't build a business around services hosted there.
And this not only goes for Hetzner but pretty much any provider whose business model is based on low margin/high throughput.     


### DO kubernetes
Single Server kubernetes on a managed platform like Digital Ocean is a lot like having a managed server but you are more flexible with separating your services.    
https://www.digitalocean.com/products/kubernetes   



### Self Managed Server Issues
 Tell HN: I DDoSed myself using CloudFront and Lambda Edge and got a $4.5k bill.   
https://news.ycombinator.com/item?id=31907374.   
> You need to document, implement and maintaing hardening, have a process for regularly patching os and apps, monitor logs, have backup and disaster recovery procedures, regularly test the procedures, figure how to implement data encryption at rest, implement high-availability and so on.
Hey, that's not exactly a correct comparison. You don't simply get half of those in the cloud either. Log monitoring and disaster recovery is something you have to figure out yourself, the best clouds have are some foundations to build upon, and possibly - some cookiecutter template that might fit your use case (if you're really lucky it'll even be decent). And you can get same stuff on traditional servers, just with different pre-baked solutions (which also may or may not fit a particular use case and may vary from perfectly good to quite crappy).    

People love to brag about all the features (most not needed for your casual website), but somehow no one tells the fact that those features just won't be there when you'll start to use the cloud - because you have to be actively aware that you need them, explicitly enable some, and explicitly spend time learning, setting up and testing others. Unless we're talking about PaaS (and not a "classic" cloud like AWS, GCP or Azure), you still need someone with some sysadmin experience - except that this person must wear a different kind of sweater (with $Cloud logo rather than Tux or Beastie).    

All you get is some hardening an OS + managed software (like LB servers and databases) patching. Which is something that's not that hard to do on a self-managed server (well, the software updates part; hardening is a rabbit hole). But not application patching, mind you - that's your responsibility to maintain your app, the very best it can do is to run a security audit (which you can get as a service separately). And even though managed databases are tuned (still a lot of manual tuning to do if you want the engine to truly purr) and maintained they aren't all that fun and peaches the marketing materials say - sometimes you just have to e.g. spin up your own self-hosted PostgreSQL to perform the tricky migration, then replicate it back to a managed solution.  
