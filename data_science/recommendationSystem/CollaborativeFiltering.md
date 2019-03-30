matrix factorization (MF) methods are designed to cope with sparsity  

KNN are not so good with sparse data. 

### CF with embeddings
part1 : https://towardsdatascience.com/collaborative-filtering-and-embeddings-part-1-63b00b9739ce
part2 : https://towardsdatascience.com/structured-deep-learning-b8ca4138b848

### CF with cosine simlarity
Based on User feature matrix find the similarity of users with other users  


### Using Alternating Least Squares (ALS) ito find similarity 
ALS is a matrix factorization algorithm. The idea is basically to take a large (or potentially huge) matrix and factor it into some smaller representation of the original matrix. ... Here we can actually use matrix factorization to mathematically reduce the dimensionality of our original “all users by all items” matrix into something much smaller that represents “all items by some taste dimensions” and “all users by some taste dimensions”. These dimensions are called latent or hidden features and we learn them from our data.  
If we can express each user as a vector of their taste values, and at the same time express each item as a vector of what tastes they represent. You can see we can quite easily make a recommendation.  


### Collaborative Filtering for Implicit Feedback Datasets using ALS
http://yifanhu.net/PUB/cf.pdf  (by Hu, Korenand and Volinsky (and used by Facebook and Spotify))   
https://medium.com/radon-dev/als-implicit-collaborative-filtering-5ed653ba39fe  

To calculate the similarity between items we compute the dot-product between our item vectors and it’s transpose. So if we want artists similar to say Joy Division we take the dot product between all item vectors and the transpose of the Joy Division item vector. This will give us the similarity score:  
To make recommendations for a given user we take a similar approach. Here we calculate the dot product between our user vector and the transpose of our item vectors. This gives us a recommendation score for our user and each item:  



