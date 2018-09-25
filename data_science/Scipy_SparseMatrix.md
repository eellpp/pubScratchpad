
`sparse matrix/array` is a matrix/array in which most of the elements are zero. \
`dense matrix` is a matrix/array where most of the elements are nonzero

sparisity = number_of_zero_value_elements/total_number_of_elements

### Storing a sparse matrix
In the case of a sparse matrix, substantial memory requirement reductions can be realized by storing only the non-zero entries. Depending on the number and distribution of the non-zero entries, different data structures can be used and yield huge savings in memory when compared to the basic approach.\

Formats can be divided into two groups:

a) Sparse types used to construct the matrices:

- DOK (Dictionary Of Keys): a dictionary that maps (row, column) to the value of the elements. It uses a hash table so it's efficient to set elements.

- LIL (LIst of Lists): LIL stores one list per row. The lil_matrix format is row-based, so if we want to use it then in other operations, conversion to CSR is efficient, whereas conversion to CSC is less so.

- COO (COOrdinate list): stores a list of (row, column, value) tuples.

b) Sparse types that support efficient access, arithmetic operations, column or row slicing, and matrix-vector products:

- CSR (Compressed Sparse Row): similar to COO, but compresses the row indices. More efficient in row indexing and row slicing, because elements in the same row are stored contiguously in the memory.

- CSC (Compressed Sparse Column): similar to CSR except that values are read first by column. More efficient in a column indexing and column slicing.

Once the matrices are build using one of the a) types, to perform manipulations such as multiplication or inversion, we should convert the matrix to either CSC or CSR format.

Coo (Coordinate) and DOK (Dictionary of Keys) are easier to construct, and can then be converted to CSC or CSR via matrix.tocsc() or matrix.tocsr().

https://en.wikipedia.org/wiki/Sparse_matrix

### Using cosine_similarity from sklearn

cosine_similarity function is between two matrices.\
A numpy array of shape(m,n) is a matrix where m is number of rows and n is number of columns\
The cosine_similarity function calculates similarity betweeb each row of the matrix A with that of matrix B

```bash
from sklearn.metrics.pairwise import cosine_similarity
x = np.array([[2,3,1,0]])
y = np.array([[1,1,1,1]])
cosine_similarity(X=x,Y=y)
## array([[0.80178373]])

x = np.array([[2,3,1,0]])
y = np.array([[2,3,1,0],[1,1,1,1]])
cosine_similarity(X=x,Y=y)
## array([[1.        , 0.80178373]])

x = np.array([[2,3,1,0],[1,1,1,1]])
y = np.array([[2,3,1,0],[1,1,1,1]])
z = np.array([[1,1,1,1]])
cosine_similarity(X=x,Y=y)
## array([[1.        , 0.80178373],
##       [0.80178373, 1.        ]])
```

For visualizing the similarity matrix output of the last one we can think as :\
x= [ a1 , a2] \
y = [b1 , b2] \
the sim matrix is \
......b1....................b2  
a1....1.....................0.80178373  \
a2....0.80178373.............1 

If X is the matrix representing the document vectors and Y is user profile matrix. Both X and Y vectors are based on same set of tags (named entities), then the rows of the resultant matrix will represent the similarity of each document to each of the user.\
For document recommendation to users, we have iterate through each row (document) and find columns (users) whose sim scores are greater than threshold. 

Since a user/document matrix would have high sparsity (> 95%), it is better to use the sparse representation for matrix computation

```bash
x = np.array([[2,3,1,0]])
y = np.array([[2,3,1,0],[1,1,1,1]])
cosine_similarity(X=csc_matrix(x),Y=csc_matrix(y))
## array([[1.        , 0.80178373]])
```

### Cosine similarity between a vector and dataframe in spark ( without using sparse matrix optimizations)

https://hashnode.com/post/cosine-similarity-between-a-static-vector-and-each-vector-in-a-spark-data-frame-cjctjlump0074dlwtfaoe0pwj

```bash
# imports we'll need
import numpy as np
from pyspark.ml.linalg import *
from pyspark.sql.types import * 
from pyspark.sql.functions import *

# function to generate a random Spark dense vector
def random_dense_vector(length=10):
    return Vectors.dense([float(np.random.random()) for i in xrange(length)])

# create a random static dense vector
static_vector = random_dense_vector()

# create a random DF with dense vectors in column
df = spark.createDataFrame([[random_dense_vector()] for x in xrange(10)], ["myCol"])
df.limit(3).toPandas()

# write our UDF for cosine similarity
def cos_sim(a,b):
    return float(np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b)))

# apply the UDF to the column
df = df.withColumn("coSim", udf(cos_sim, FloatType())(col("myCol"), array([lit(v) for v in static_array])))
df.limit(10).toPandas()
```
References:
- https://medium.com/@rantav/large-scale-matrix-multiplication-with-pyspark-or-how-to-match-two-large-datasets-of-company-1be4b1b2871e

```bash
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
# these would realistically get read from files or dataframes. 
a = ['google inc', 'medium.com', ...] 
b = ['google', 'microsoft', ...]
stopwords = ['ltd', ...]
vect = CountVectorizer(stop_words=stopwords)
# this can be done with less memory overhead by using a generator
vocabulary =  vect.fit(a + b).vocabulary_
tfidf_vect = TfidfVectorizer(stop_words=stopwords,
                             vocabulary=vocabulary)
a_mat = tfidf_vect.fit_transform(a)
b_mat = tfidf_vect.fit_transform(b)
a_mat_para = parallelize_matrix(a_mat, rows_per_chunk=100)
b_mat_dist = broadcast_matrix(a_mat)
a_mat_para.flatMap(
        lambda submatrix:
        find_matches_in_submatrix(csr_matrix(submatrix[1],
                                             shape=submatrix[2]),
                                   b_mat_dist,
                                   submatrix[0]))
def find_matches_in_submatrix(sources, targets, inputs_start_index,
                              threshold=.8):
    cosimilarities = cosine_similarity(sources, targets)
    for i, cosimilarity in enumerate(cosimilarities):
        cosimilarity = cosimilarity.flatten()
        # Find the best match by using argsort()[-1]
        target_index = cosimilarity.argsort()[-1]
        source_index = inputs_start_index + i
        similarity = cosimilarity[target_index]
        if cosimilarity[target_index] >= threshold:
            yield (source_index, target_index, similarity)
def broadcast_matrix(mat):
    bcast = sc.broadcast((mat.data, mat.indices, mat.indptr))
    (data, indices, indptr) = bcast.value
    bcast_mat = csr_matrix((data, indices, indptr), shape=mat.shape)
    return bcast_mat
def parallelize_matrix(scipy_mat, rows_per_chunk=100):
    [rows, cols] = scipy_mat.shape
    i = 0
    submatrices = []
    while i < rows:
        current_chunk_size = min(rows_per_chunk, rows - i)
        submat = scipy_mat[i:i + current_chunk_size]
        submatrices.append((i, (submat.data, submat.indices, 
                                submat.indptr),
                            (current_chunk_size, cols)))
        i += current_chunk_size
    return sc.parallelize(submatrices)
```


### Distributed matrix in spark : RowMatrix,IndexedRowMatrix,CoordinateMatrix and Block Matrix
https://spark.apache.org/docs/2.3.0/mllib-data-types.html

A `RowMatrix` is a row-oriented distributed matrix without meaningful row indices, e.g., a collection of feature vectors. It is backed by an RDD of its rows, where each row is a local vector. We assume that the number of columns is not huge for a RowMatrix so that a single local vector can be reasonably communicated to the driver and can also be stored / operated on using a single node.

An `IndexedRowMatrix` is similar to a RowMatrix but with row indices, which can be used for identifying rows and executing joins.

A `CoordinateMatrix` is a distributed matrix stored in coordinate list (COO) format, backed by an RDD of its entries. \
A `BlockMatrix` is a distributed matrix backed by an RDD of MatrixBlock which is a tuple of (Int, Int, Matrix).

- https://stackoverflow.com/a/46764347



### References
[Sparse Matrices For Efficient Machine Learning](https://dziganto.github.io/Sparse-Matrices-For-Efficient-Machine-Learning/)\
[Working with Sparse Matrices](http://www.mathcs.emory.edu/~cheung/Courses/561/Syllabus/3-C/sparse.html)\
[Sparse Matrix Representations & Iterative Solvers](http://www.bu.edu/pasi/files/2011/01/NathanBell1-10-1000.pdf)\
[Sparse matrices - scipy.sparse](https://docs.scipy.org/doc/scipy/reference/sparse.html)
