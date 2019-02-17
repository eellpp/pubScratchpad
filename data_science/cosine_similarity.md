 
 ### What is the cosine similarity between these vectors and why ?

a)\
dataSetI = [0, 0, 0, 1]\
dataSetII = [1,1, 1,0]

b)\
dataSetI = [0, 0, 0, 1]\
dataSetII = [1,1, 0,0]

c)\
dataSetI = [0, 0, 0,1]\
dataSetII = [1,1, 0,1]

d)\
dataSetI = [0, 0, 0, 1]\
dataSetII = [1,1, 1,1]

e)\
dataSetI = [0, 0, 0, 1]\
dataSetII = [1111,45, 80,1000]

Answers
- a: 0
- b: 0
- c: 0.57
- d: 0.5
- e: 0.66

The cosine similarity looks at “directional similarity” rather than magntudinal differences.

Why cosine similarity is useful in text analytics ?\
Cosine similarity is often used in information retrieval, within the Vector Space Model, in which a document (i.e. a piece of text) is represented as a vector of all its terms (words), by using term frequency (or tf-idf, or variants thereof). In that model, it is beneficial to abstract out the magnitude of the term vector because it takes out the influence of the document length: only the relative frequencies between words in the document, and across documents, are of importance, and not how big the document is. This enables that e.g. in computation of document similarity big documents do not always come on top.


