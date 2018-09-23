
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


