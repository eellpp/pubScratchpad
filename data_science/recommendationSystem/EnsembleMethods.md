
An Analysis of Recommender Algorithms for Online News  
https://pdfs.semanticscholar.org/43d1/f2063fe51a65b2c41e909c2b56f72ae7bfe3.pdf

`Ensemble Recommendations` are produced based on a combination of all the popularity- and content-based recommenders below. The candidate set is the union of candidate sets from each recommender. Candidate articles are then ranked using the sum of the rankings for the top n articles from each recommender. If, for any recommender, an article does not occur in the top n recommendations, it receives the maximum ranking of n, plus a penalty of 1, as in equation 1. We set n = 100 in these experiments.

### Content Based recommenders
Content - Title and Summary The candidate set is all articles, represented by the terms in their titles and summaries.  
Content - Title and Summary + Freshness As above, but candidate set articles must also be fresh i.e. published or updated in the last 24 hours.  
Content - Title and Summary + New As above but candidate set articles must be brand new i.e. published in the last hour, rather than fresh.  
Content - Keywords The candidate set is all articles, represented by their keywords provided by Plista (recall that Plista provides a set of keywords and their frequencies within a document, although how the keywords are selected, or what they actually are is not disclosed).  
Content - German Entities The candidate set is all articles, represented by their entities; using AlchemyAPI we extract entities, in German, from the full text of the articles.  
Content - English Entities The candidate set is all articles, represented by their entities. This time, we use Google Translate to first translate the articles into English and then use OpenCalais to extract entities from the full text of the articles.  
Content - English Entities in Context Expanding on the previous recommender, we represent articles using both their entities and the context surrounding them in the article. In OpenCalais context represents the relevant text before and after an entity.  
Positive Implicit Feedback The candidate set is all articles that have been successfully recommended in the past (by any team’s algorithm) to some user, i.e. clicked by the user. The more popular an article is as a recommendation, i.e. the more clicks it has, the higher the algorithm ranks it.  
Most Recent The candidate set is all articles in the dataset. Candidate articles are then ranked in reverse chronological order of when they were published or updated.  
