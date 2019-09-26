 
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

### Why cosine similarity is useful in text analytics ?  
Cosine similarity is often used in information retrieval, within the Vector Space Model, in which a document (i.e. a piece of text) is represented as a vector of all its terms (words), by using term frequency (or tf-idf, or variants thereof). In that model, it is beneficial to abstract out the magnitude of the term vector because it takes out the influence of the document length: only the relative frequencies between words in the document, and across documents, are of importance, and not how big the document is. This enables that e.g. in computation of document similarity big documents do not always come on top.

### Cosine Similarity formula

sim = (dot product of vectors) / ( SQRT(sum_of_squares_vec1) * SQRT(sum_of_squares_vec2) )

### Cosine Similarity in pure python
```
def get_cosine(vec1, vec2):
         intersection = set(vec1.keys()) & set(vec2.keys())
         numerator = sum([vec1[x] * vec2[x] for x in intersection])

         sum1 = sum([vec1[x]**2 for x in vec1.keys()])
         sum2 = sum([vec2[x]**2 for x in vec2.keys()])
         denominator = math.sqrt(sum1) * math.sqrt(sum2)

         if not denominator:
            return 0.0
         else:
            return float(numerator) / denominator
```

### Cosine similarity vs pearson correlation
Pearson correlation and cosine similarity are invariant to scaling, i.e. multiplying all elements by a nonzero constant. Pearson correlation is also invariant to adding any constant to all elements. 
For example, if you have two vectors X1 and X2, and your Pearson correlation function is called pearson(), pearson(X1, X2) == pearson(X1, 2 * X2 + 3). This is a pretty important property because you often don't care that two vectors are similar in absolute terms, only that they vary in the same way.

### Intuition for cosine sim
Given a set of docs with freq of terms A and B :  
doc1 = [5,9]  
doc2 = [8,18]  

cosine_sim can be used to calculate how similar these two docs are. The way its calculating that by hypothesising that if the co-occurance frequency of terms in doc1 and doc2 are same, then they are similar. Just that doc2 is longer than doc1, but in meaning its similar to doc1.  

```bash
# import from sklearn pariwise
cosine_similarity([[5,9]] , [[8,18]])  
0.99605

# import from scipy
pearsonr([5,9],[8,18])  
(1,0)
```

Lets assume that the idf calculated for term A and B are 1.5 and 0.05 respectively . So using the tfidf scores for each doc  

```bash
# import from sklearn pariwise
cosine_similarity([[5*1.5,9*0.05]] , [[8*1.5,18*0.05]])  
0.99469

# import from scipy
pearsonr([5*1.5,9*0.05],[8*1.5,18*0.05])  
(1,0)
```
pearson correleation is not affected by the IDF measurse. Since idf scales the same term across docs in constant way, it has no effect in calculating correlation  



