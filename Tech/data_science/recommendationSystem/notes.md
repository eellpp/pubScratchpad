
### Content-based recommender systems
In content based systems, the content features are considered for building the recommendations. This is unlike the collaborative method where features are not considered and only similarity user-user or content-content is considered. Thus content based recommendation is more personalized based on individual preferences.

User preferences (or UserProfile) is compared with Item Properties.\
Example would be suggest you content based on content you have already accessed.

#### Considerations
1. How to select the features of the content
2. How to select preferences of the user such that they are similar to that of the content
3. How to compute similarity
4. How do we create and update profiles continuously


#### Selecting content features 
Most common method is to represent the content as vector space model with contentid as rows and features as columns\
The weights for each features are assigned by different algorithms. Generally used in tf-idf \
where \
tf = raw count of frequency of term T in the document \
idf = log(TotalNumDocs/documentfrequencyWhereTermTAppears) \
weight = tf*idf

https://en.wikipedia.org/wiki/Tf%E2%80%93idf

ItemTagMatrix : Items X Tags (tag freq in item)\
Do the tf-idf on this to get the weights

UserItemMatrix : User X Items (Items accessed by user : freq)\
UserTagMatrix : dotProduct(UserItemMatrix X ItemTagMatrix)

CosineSimilarity(UserTagMatrix * ItemTagMatrix) \
gives UserItemMatrix which shows weights for user against each item

The profile is based on tags which acts as the latent variable in profile building approach.

Content based model target at an individual level at a particular user preferences rather than community preferences. This is faster as the model does not need to load all the users data for generating recommendations. Also the accuracy will be higher but recommendation would be narrowed to just past preferences. The user may miss on the latest trends etc.

### Collaborative filtering 
This approach is used when we don't have features for the item. Instead we have a rating or like/dislike selection etc for the item.\
These are of two types
1. User based
2. Item based

The underlying idea in both these approaches is that instead of relying on the features of the content, based on past data find users or items that are similar and in future if one of user chooses an item then recommend it to all users similar to him [1] or similar to the product [2].

`User based`: Users can be considered on X axis and Products on Y axis. The point in XY plane are the user ratings. Computing the Euclidean distance between points computes the similarity between users. In future, similar users can be recommended items based on what other users have selected.

`Item based`: This is based on the intuition that user liked item A in past then in future, he may like item B which is similar to item A.
Items are represented in vector space and similarity between items is calculated using cosine similarity. Item based similarity is calculated based on co-rated items.


### Model Based Recommendation
The similarity based recommendation system invovles loading the entire past historical data into memory. This makes them slow and not suitable for real-time recommendations. \
In model based approach , using historical data a model is build with weights learned automatically. New predictions regarding the product will be made using learned weight each time user action is performed. In similarity based approach the weights are not learned real-time\
1. Probabilistic models like Naive Bayes
2. Non Probabilistic models like logistic regression, SVM, clustering etc
2. Matrix Factorization models like SVD


#### Vector Space Model vs Exact Boolean Match
When exact match is required we can use the boolean query method. When approx match is required, we can use the similarity based method. 

Boolean : This is yes or no match \
Similarity : These are partial matches between 0 and 1. 

#### Issues with Similarity based approaches
Synonyms and polysems (same word with multiple meanings : java)

#### LSA (latent semantic analysis)
LSA aims to discover something about the meaning behind the words; about the topics in the documents which are latent.\
LSA puts documents together even if they don't have common words. Instead it tries to see if the documents share co-occuring terms

Term Document Matrix A : m X n \
Term Matrix U : m X r \ 
Sigma Matrix S : r X r \
Document Matrix V: r X n

A =(decomposed to)= U S V \
Then dimension reduction is done \
Now recreating A with reduced dimension gives the weights of terms in documents which can be used for similarity computation

#### Probabilistic LSA (PLSA)
PLSA adds a statistical foundation to LSA based methods. PLSA generates a model and maximizes its predictive power. Since PLSA has strong statistical foundation, it can select the optimal params to maximize its predictive power. In LSA the params are generated on heuristic 

#### LDA
Latent Dirichlet allocation (LDA) addresses the problems faced by PLSA \
This is widely used for topic modelling.

### Memory based vs Model based


### Model based approaches
- Clustering based (KNN, SVD)
- Matrix Factorization ()
- Deep Learning based

### General Notes
Given a dataset based on some documents and their categories tags, the simplest approach is to start with a content/collaborative method where the a past n months user profile dataset is created and loaded in memory. The cosine similarity between unread new documents and this user profile gives the weights for each document for the user. This becomes the data on the which the recommendations can be performed.\
Advantages
- simple intuitive approach 
- works well on small dataset where content tags is clearly described (without synomys and polynyms)
- not scalable
- cannot be used on large datasets where latent features needs to used
- cannot perform statistical optimizations based on hyper params selection for model selection



#### References
- https://courses.cs.washington.edu/courses/cse573/12sp/lectures/17-ir.pdf
- [Model Base Collaborative Filtering alorithms - medium blog ](https://medium.com/recombee-blog/machine-learning-for-recommender-systems-part-1-algorithms-evaluation-and-cold-start-6f696683d0ed)
- [various implementations of collaborative model based recommendations] (https://towardsdatascience.com/various-implementations-of-collaborative-filtering-100385c6dfe0)
- [using embeddings to create a model based system](https://towardsdatascience.com/structured-deep-learning-b8ca4138b848)
