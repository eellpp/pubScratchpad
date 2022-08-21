
### A Product Recommendation System Using Vector Space Model and Association Rule
This paper presents an alternative product recommendation system for Business-to-customer e-commerce purposes. The system recommends the products to a new user. It depends on the purchase pattern of previous users whose purchase pattern are close to that of new user. The system is based on vector space model to find out the closest user profile among the profiles of all users in database. It also implements Association rule mining based recommendation system, taking into consideration the order of purchase, in recommending more than one product. \
https://www.researchgate.net/publication/232634921_A_Product_Recommendation_System_Using_Vector_Space_Model_and_Association_Rule

### User Profile Vector
This is based on user feedback. User feedback canbe explicit and implicit. Implicit feedback is based on user actions and is considered more accurate.


### Suggestions
Several factors can be considered in determining which documents should be suggested to the user:

- The similarity between a document vector and the profile vector can be calculated using several similarity measurements. Cosine similarity is the popular method used 
- The novelty of a document is determined by the existence of information in a document that is new to the user.
- The proximity of a document is determined by the minimal number of links it takes to navigate from the current page to a page that presents the document. Mobasher et al. [Mobasher et al. 1999b] for example take the log of the number of links as a measurement of distance.
- Some recommender systems also check if a document is relevant to the information shown on the current page.


### Learning models
A learning model is created on training data. If numerical data (buying frequency) is used for training, then regression methods can be used. If binary act of selecting or not selecting is used, then classification methods are choosed.

Let D be the n x d matrix representing  n documents and d words in lexicon

Let Y be the n dimensional column vector representing the rating of an user for all n documents in training set

Let W be d dimensional row vector representing the coefficients of each word in the linear function relating word frequency to ratings

Y ~ D(W)Transpose

## Algorithms
---

### User Clusters
Improve relevance of recommendations in high churn media services.\
Cluster users based on historical activity.\
configurable taxonomy (category, price range, brand, visit referrer, ..)\
unsupervised (fuzzy k-means)\
Apache Spark to handle large historical data sizes.\
Load user clusters into front-end servers periodically and count content hits for users in same cluster\
Decay counts to provide activity dynamics as new content is published.\
Recommend by combining counts for content based on cluster membership of user.\
Real-time stream processing for adding short-term dynamics to recommendations.

### Tag Affinity
Combine metadata with trending articles\
Model associates users with weights to tags from content.\
At runtime find trending articles with tags associated with user.\
Combine results for recommendations.\
Can be used to find niche user clusters.

### Item Activity Correlation
Built for static slowly changing historical inventory\
Similar to Amazon’s “people who bought this also bought…”\
Use historical user activity to find items that share similar user activity.\
Apache Spark scalable offline implementation.\
Upload for each item: top-N similar items.\
For each user: item recommendations based on their historical activity.

### Topic Models
Built for sites needing long tail recommendation \
Assume activity is associated with a set of topics. \
Users individuals tastes are covered by a subset of topics. \
Describe users by the set of keywords for the items they have interacted with.\
Built with Apache Spark and Vowpal Wabbit implementation of Latent Dirichlet Allocation.\
Online serving layer scores user association with items in real time.

### Latent Factor Models
Best for e-commerce sites lower churn sites \
Netflix Prize winning solution. \
Use Matrix Factorization to reduce activity matrix to two low dimension user and item factor matrices. \
Load factors into API servers and score users and items in real time.\
Fold-in new users and items until next batch update of model. \
Utilize Apache Spark mllib and streaming modules.

### Content Similarity
Built for services with rich metadata and high sparsity \
Requirement – fast content based technique to match user history to similar content based on text/tags of content. \
Utilize random vectors technique. Each word/tag is assigned a random high-dimensional vector. \
Open-source Semantic-Vectors implementation. \ 
Periodically process recent content into vectors and update servers. \
Servers load vectors into memory. \
Recommendation on recent user activity to find similar content in real-time. 

### Association Rules
Suggested the next best item given current set of items \
A form of basket analysis that is useful in e-commerce to provide recommendations for which items could be added to a basket given a current set of items. \
There are two Spark jobs that need to be run consecutively: \
1. Basket Analysis: break up the actions event stream and process the add-to-basket and remove-from-basket events and create a set of session baskets. \
2. Association Rules : This will process the baskets , find frequent item sets using the Spark MLib FP Growth algorithm and create association rules. \

### Algorithm Optimization
Cascade multiple algorithms to cover different users. \
Combine algorithm results in different ways, e.g. weighted scores, rank combine. \
Run A/B and Multivariate tests with no redeploy \
Select algorithm strategies via API tags: \
- to handle user cohorts: mobile users, desktop, tablet
- to provide multiple content recommendations per page, sitewide, insection.
Change all configuration in real time with no redeployment. \
Dynamic optimisation with multi-armed bandits. 

### Books
Building Recommendation Engines


References
- https://getstream.io/blog/best-practices-feed-personalization/
- https://www.quora.com/Which-algorithms-are-used-in-recommender-systems
- https://techcrunch.com/2016/09/06/ultimate-guide-to-the-news-feed/
