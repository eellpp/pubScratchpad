https://news.ycombinator.com/item?id=26203074  

- Choose boring technology. Especially when alone I prefer reliability and tons of state of the art of how to operate it, over shiny features  
- Choose technolgy and infrastructure that you know. It is a whole lot easier to maintain a stable system with something that you have ample experience with.  
- Keep system complexity roughly aligned with you team size. E.g. when alone, it might not be the best idea to maintain 5 very different database systems altough on paper each is "the best tool for the job"  
- I don't think you need any super advanced, well tought out archiecture, but if you are constantly fire fighting while at work, it might not be even good enough  
- Setup basic automation so the system can recover from the unavoidable but benign hickup every now and then.  
- Don't deploy before going for lunch, coffee break, dinner, weekends, etc.  
- Observe your systems behaviour over time, and especially the impact of changes on it. If you see a degradation, fix it or at least put it in the backlog. Otherwise it will bite you eventually out of nowhere.  
- Have nice error pages and messaging that are shown to users when the system fails. In my experience in early stage companies, crashes suck, but aren't actually to bad after all and users are quite lenient as long as they see that the system is down instead of having the bad experience of it just not working correctly and them wasting time.  

