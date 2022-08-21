Collaborative filtering models can be generally split into two classes: 
1. user- and 
2. item-based collaborative filtering. 
In either scenario, one builds a similarity matrix. For user-based collaborative filtering, the user-similarity matrix will consist of some distance metric that measures the similarity between any two pairs of users. Likewise, the item-similarity matrix will measure the similarity between any two pairs of items.


matrix factorization (MF) methods are designed to cope with sparsity  

KNN are not so good with sparse data. 

## CF with memory based method (Cosine Similarity)
Memory-Based Collaborative Filtering approaches can be divided into two main sections: user-item filtering and item-item filtering. A user-item filtering takes a particular user, find users that are similar to that user based on similarity of ratings, and recommend items that those similar users liked. In contrast, item-item filtering will take an item, find users who liked that item, and find other items that those users or similar users also liked. It takes items and outputs other items as recommendations.  

In the above, memory based appeoach we are not learning any parameter using any optimization algo (eg: gradient descent). In model based approach we use these optimization algo to build our model.

https://www.ethanrosenthal.com/2015/11/02/intro-to-collaborative-filtering/

## CF with Model based approach
1. Clustering : KNN
2. Matrix Factorization : SVD, ALS 
3. Deep Learning : multiple layers including neural networks

### CF with embeddings
part1 : https://towardsdatascience.com/collaborative-filtering-and-embeddings-part-1-63b00b9739ce
part2 : https://towardsdatascience.com/structured-deep-learning-b8ca4138b848

### CF with cosine simlarity
Based on User feature matrix find the similarity of users with other users  


### Using Alternating Least Squares (ALS) ito find similarity 
ALS is a matrix factorization algorithm. The idea is basically to take a large (or potentially huge) matrix and factor it into some smaller representation of the original matrix. ... Here we can actually use matrix factorization to mathematically reduce the dimensionality of our original “all users by all items” matrix into something much smaller that represents “all items by some taste dimensions” and “all users by some taste dimensions”. These dimensions are called latent or hidden features and we learn them from our data.    
If we can express each user as a vector of their taste values, and at the same time express each item as a vector of what tastes they represent. You can see we can quite easily make a recommendation.  

##### ALS method
ALS is an iterative optimization process where we for every iteration try to arrive closer and closer to a factorized representation of our original data.

`R = U X V`  
where  
R : Original Matrix of users X Items  
U : factorized matrix of users X LatentFeatures  
V : factorized matrix of LatentFeatures X Items  

By randomly assigning the values in U and V and using least squares iteratively we can arrive at what weights yield the best approximation of R. The least squares approach in it’s basic forms means fitting some line to the data, measuring the sum of squared distances from all points to the line and trying to get an optimal fit by minimising this value.

With the alternating least squares approach we use the same idea but iteratively alternate between optimizing U and fixing V and vice versa. We do this for each iteration to arrive closer to R = U x V.


### Collaborative Filtering for Implicit Feedback Datasets using ALS
http://yifanhu.net/PUB/cf.pdf  (by Hu, Korenand and Volinsky (and used by Facebook and Spotify))   
https://medium.com/radon-dev/als-implicit-collaborative-filtering-5ed653ba39fe  

To calculate the similarity between items we compute the dot-product between our item vectors and it’s transpose. So if we want artists similar to artistXXX, we take the dot product between all item vectors and the transpose of the artistXXX item vector. This will give us the similarity score:  
To make recommendations for a given user we take a similar approach. Here we calculate the dot product between our user vector and the transpose of our item vectors. This gives us a recommendation score for our user and each item:  

##### Implicit Feedback
There are different ways to factor a matrix, like Singular Value Decomposition (SVD) or Probabilistic Latent Semantic Analysis (PLSA) if we’re dealing with explicit data.

With implicit data the difference lies in how we deal with all the missing data in our very sparse matrix. For explicit data we treat them as just unknown fields that we should assign some predicted rating to. But for implicit we can’t just assume the same since there is information in these unknown values as well. As stated before we don’t know if a missing value means the user disliked something, or if it means they love it but just don’t know about it. 


