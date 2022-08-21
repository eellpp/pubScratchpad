While for-loop syntax in Python is flexible and provides wonderful utility, each iteration over an element is essentially a single step in the route through all elements of the container object. This step-through processing is useful when the order of operation matters (e.g., returning the first item in a list that meets a certain condition).
Vectorized processing, in contrast, may be applied when the order of processing does not matter.  

In NumPy and Pandas, separate segments of arrays are processed amongst all of the processing cores of your computer. NumPy and Pandas operate on their arrays and series in parallel, with a segment of each array being worked on by a different core of your computer’s processor.  


### Single Instruction, Multiple Data (SIMD)
This is the structure for how NumPy and Pandas vectorizations are processed—One instruction per any number of data elements per one moment in time, in order to produce multiple results. Contemporary CPUs have a component to process SIMD operations in each of its cores, allowing for parallel processing.  

Not all operations in pandas and numpy use SIMD instructions.  
When using functions supporting SIMD all the cores of the CPU will get engaged avoiding python GIL lock.  

np.vectorize is function that supports vectorization.   
https://pandas.pydata.org/pandas-docs/stable/user_guide/basics.html#vectorized-string-methods  
