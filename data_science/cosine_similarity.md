 
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


