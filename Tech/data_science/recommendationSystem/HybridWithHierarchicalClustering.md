

https://blog.insightdatascience.com/news4u-recommend-stories-based-on-collaborative-reader-behavior-9b049b6724c4

### Non Personalized, group based recommendation system based on user groups

> By looking at how many news posts two users share in common, I can define a cosine similarity score for the users. This similarity score enables the construction of a network by weighting the links between users. 

> By applying a hierarchical clustering algorithm to the user network, I can detect the community structures among the readers.

> The modularity is an important metric for network clustering, which indicates how dense the connections within clusters are compared to the connections between different clusters.Any real-world network will have a modularity value between 0 and 1. In my user network, the modularity score of the hierarchical clustering algorithm peaks at 6 clusters with value 0.151.

>  LDA  is used to understand how much of an article is devoted to a particular topic, which allows the system to categorize an article, for instance, as 50% environment and 40% politics.

>  The diversity of topics is evaluated by the average Jaccard similarity between topics; this index measures similarity between two finite sample sets, and is defined as the size of the intersection divided by the size of the union of the sample sets. High Jaccard similarity indicates strong overlap and less diversity between topics, while low similarity means the topics are more diverse and have a better coverage among all the aspects in the articles.

> With the topic information of each article, I can learn the topic interests of each user group by summarizing the topics of the popular articles in each reader group. By aggregating the topics of each article weighted by the number of retweets, I obtained the topic probability distribution for all of the six user groups. 

> Now that I have divided the users into different groups based on their similarity and identified their interests among different topics, the next step is to recommend fresh news by matching the topics of the article with the topic profile of each user group.

>  The predicted score from the recommending system is the cosine similarity between the topics of an article and the topics in a user group, which ranges from 0 to 1.

### Testing in User Group
> If the article is retweeted by more than a threshold number of users in a group, it is considered as good (1) else bad (0) 

>  From 10 rounds of validations with 1000 hold-out articles, the average precision score of our recommending system is 65.9%, while the average recall is 66.5%.





