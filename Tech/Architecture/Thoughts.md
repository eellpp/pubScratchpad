
### Software Development is knowledge building
`The main value in software is not the code produced, but the knowledge accumulated by the people who produced it.`  
ref : https://www.csc.gov.sg/articles/how-to-build-good-software  

You have to start with bad software, keep building your knowhow. Keep pruning and improving. Their would be multiple iterations of code increase and code reduction (refactoring technical debt). Their would be occasional pivot.  
All these are knowledge that team building the software keeps. This knowledge is lost when observing only the final source code as the output. When the team holding that knowledge departs, the software degrades. The future updates will miss the key insights from past. It will be long time when the new team makes the same mistakes and learns over in iterations.  
If there is constant team overhauls, then software will turn to crap.  

#### Why use popular frameworks

>  a great advantage of established frameworks is that they provide a coding standard for a team. People who do this stuff every day can easily follow the standard, understand the flow and be very productive. They did invest lots of time to learn about all those tools and libraries and probably had an overall productivity gain compared to writing native JS.

> The productivity gained by agreeing on a framework usually outweighs the performance loss over the "best" solution. Yes, my native JS implementation of a gallery app is much faster than the React version (reviewed by an experienced React-dev and judged "good") but if that project goes public and other people have to work on it I'll be damned if I make them learn my way of doing things. I'd expect these devs to implement a feature quickly and that means they use the framework they are most comfortable with. If it is good enough, it is good enough.

> Aiming for perfection killed way too many projects, accepting that the productive path is not always the nicest or cleanest (according to some arbitrary metric) is what makes projects succeed.

#### Devs need to be comfortable with framework before getting benefits of framework
> Making devs use an unknown framework without time to learn it will result in a project that doesn't use that framework properly. Thousands of lines of code will be written... to duplicate functionality the framework already provides, but that the devs don't know exist. The rush of deadlines means that the devs skip reading documentation or researching the "right way" to do every task, and you wind up with a project that technically uses the framework... except that the entire project will be written in a way that someone with previous experience with that framework would never have allowed to happen.

#### How to choose new tech
There's a range of options between "I watched an hour video and saw a cool demo" and "I invested six months into prototyping and testing the tech before I chose it."

> Try searching "$TECH sucks" and similar queries on the Internet. If you can't find anything, that's not a sign the tech is too awesome to have flaws... it's a sign nobody's using it! Of course, you need to learn how to balance the hype vs. the "sucks" options. The question is not whether somebody has something bad to say, the question is what bad things they say. Are they clearly using it wrong? Are they clearly using it in a use case the software doesn't even claim to support? Or... are they using it in exactly your use case in exactly the way you wanted to use it and encountered fundamental problems?

check the hard things
> If you do do a test deployment, don't fall into the trap of deploying at a radically smaller size than you need. If you're going to need the tech to work in clustered mode, for instance, don't deploy it to a single server and deploy three records to it. Deploy it in a cluster mode and load it up with 10-100x times the data you think it's going to have. You can't practically test the complexity of the app you wan to write without actually writing it, but you usually can test the size. Test your most complicated case; if you've got a web app and you want a framework to help you out, don't make the simple "user prefs" page, as soon as you can start working on the most complicated page in the site, which is probably the one that's the payload. Easy things being easy isn't an interesting test; check the hard things.
 You can make anything look good by only considering the positives, you can make anything look bad by only considering the negatives. Always look at both for all options. Get that experienced person to help you through it.
 
 > For whatever task it is you are looking to do, figure out which problems you are most likely to have, and prioritize your analysis to focus on those. Do you know you need total CP consistency? Then you can quickly eliminate entire choices by whether they even claim it, and further eliminate more by checking whether they actually maintain it in the field on their user fora. Do you have price constraints? Bam, entire choices knocked out. 
 
 
