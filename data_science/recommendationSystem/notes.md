
### Content-based recommender systems
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


