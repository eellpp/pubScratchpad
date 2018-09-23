
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

