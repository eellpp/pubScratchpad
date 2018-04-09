
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
