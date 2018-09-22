
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

- CSR (Compressed Sparse Row): similar to COO, but compresses the row indices. Holds all the nonzero entries of M in left-to-right top-to-bottom ("row-major") order (all elements in the first row, all elements in the second row, and so). More efficient in row indexing and row slicing, because elements in the same row are stored contiguously in the memory.

- CSC (Compressed Sparse Column): similar to CSR except that values are read first by column. More efficient in a column indexing and column slicing.

Once the matrices are build using one of the a) types, to perform manipulations such as multiplication or inversion, we should convert the matrix to either CSC or CSR format.

https://en.wikipedia.org/wiki/Sparse_matrix
