
https://knightlab.northwestern.edu/2016/03/28/a-quick-look-at-recommendation-engines-and-how-the-new-york-times-makes-recommendations/
> The NYT uses a natural language processing technique called Latent Dirichlet Allocation ...  
----
https://open.blogs.nytimes.com/2015/08/11/building-the-next-new-york-times-recommendation-engine/?_r=0  
> Our first recommendation engine used these keyword tags to make recommendations. Using tags for articles and a user’s 30-day reading history, the algorithm recommends articles similar to those that have already been read.

Disadvantages of content model approach
> However, this method relies on a content model that, sometimes, has unintended effects. Because the algorithm weights tags by their rareness within a corpus, rare tags have a large effect.   

Disdvantages of collaborative approach  
> However, this approach fails at recommending newly-published, unexplored articles: articles that were relevant to groups of readers but hadn’t yet been read by any reader in that group. A collaborative filter might also, hypothetically, cluster reading patterns in narrow viewpoints.  

Collaborative Topic Modeling
> We built an algorithm inspired by a technique, Collaborative Topic Modeling (CTM), that (1) models content, (2) adjusts this model by viewing signals from readers, (3) models reader preference and (4) makes recommendations by similarity between preference and content.

This is a three-part challenge:  
Part 1: How to model an article based on its text.  
Part 2: How to update the model based on audience reading patterns.  
Part 3: How to describe readers based on their reading history.  

First, our algorithm looks at the body of each article and applies Latent Dirichlet Allocation (LDA)  
By adding offsets to model topic error, as described in the CTM paper, our algorithm incorporates reading patterns on top of content modeling to create a hybrid approach.  
The CTM algorithm works by iteratively adjusting offsets and then recalculating reader scores. It runs until there is little change in either.  
we needed a quick way to calculate reader preferences, which can occur after finalizing article topics.  
The back-off approach makes a more conservative estimate of preferences, allowing us to be more robust to noisy data. It also, we’ve noticed, brings readers out of niches and exposes them to different, “serendipitous” recommendations.  


---------
## People Topic Modelling and Content Recommendation Algorithm  
1. Groups all touchpoints (user interactions) by person  
2. For each person  
  a) Selects contents user has interacted  
  b) Clusters contents TF-IDF vectors to model (e.g. LDA, NMF, Kmeans) person’ topics of interest (varying the k from a range (1-5) and selecting the model whose clusters best describe cohesive topics, penalizing large k)  
  c) Weights clusters relevance (to the user) by summing touchpoints strength (view, like, bookmark, …) of each cluster, with a time decay on interaction age (older interactions are less relevant to current person interest)  
  d) Returns highly relevant topics vectors for the person,labeled by its three top keywords  
3. For each people topic  
  a) Calculate the cosine similarity (optionally applying Pivoted Unique Pivoted Normalization) among the topic vector and content TF-IDF vectors  
  b) Recommends more similar contents to person user topics, which user has not yet People Topic Modeling and Content Recommendations algorithm  

----
https://medium.com/@varruunjain/collaborative-topic-modelling-using-natural-language-processing-b2f3b3b2f87b
> The approach has intuitive appeal: If a user read ten articles tagged with the word “GDP Growth,” they would probably like future “GDP Growth”-tagged articles. And this technique performs as well on fresh content as it does on older content since it relies on data available at the time of publishing.
But content-based method provides a limit degree of novelty since it has to match up the features of profile and items. A totally perfect content-based filtering may suggest nothing “surprising”. Also, for a new user: when there’s not enough information to build a solid profile for a user, the recommendation cannot be provided correctly.

> To accommodate the shortcomings of the previous method Collaborative topic modelling (CTM) comes handy. CTM, model contents, it adjusts this model by viewing signals from readers, models reader preference and makes recommendations by the similarity between preference and content.
