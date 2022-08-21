
> commit messages to me are almost as important as the code change itself
This is high on my list of code craftsmanship points. It's very difficult to explain to young programmers who have never worked on an old code base how valuable this is when done well. In fact, often you hear complaints about how a code base "is crap", but more often than not I'd wager this is just a result of the context at the time not being known or appreciated. Frankly, all code we write is heavily governed by context we take for granted at the time, but is in precious short supply 1, 5, 10 years later. If you come back with a different use case later, the original code may very well be unsuited for that purpose. We can argue all day about good judgement and YAGNI, but at the end of the day no one can see all ends, therefore the best we can do is document clearly why we did what we did.

Taking the time to rebase, cleanup, and explain your changes in detail will pay huge dividends for any long-lived project. I've literally had successors write me a thank you note for a commit message from over a decade ago because I take this so seriously.

https://chris.beams.io/posts/git-commit/
