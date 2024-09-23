In Java, **cache locality** refers to how data is accessed and stored in memory. 

**Cache locality** is crucial for performance, but Java's **automatic memory management (garbage collection)** limits control over memory layout. 

Unlike languages like C or C++, where you control how data is stored contiguously in memory (which can improve cache performance), Java abstracts this away. Data like objects in a heap may not be stored sequentially, resulting in less efficient use of CPU caches. 

To maintain good cache locality in Java, developers need to optimize data structures and access patterns intentionally.

### Off-heap storage
**Off-heap storage** refers to memory that is allocated outside of the Java heap, meaning it is managed directly by the application instead of the Java Virtual Machine (JVM) and its garbage collector. This provides advantages such as reducing the **garbage collection overhead** for large datasets, which can improve performance in memory-intensive applications like Ehcache.

Regarding memory layout, off-heap storage can provide **contiguous memory allocation** depending on how it's managed. This results in better **cache locality** and more predictable memory access patterns, which can speed up performance.

## JNI
off-heap storage often uses Java Native Interface (JNI) to access and manipulate memory directly, bypassing the JVM’s managed heap. JNI allows Java applications to interact with native libraries, enabling them to allocate and manage memory outside the JVM’s garbage-collected space.

Using JNI, off-heap memory can be allocated in contiguous blocks, which can improve performance by reducing garbage collection overhead and enhancing cache locality. Direct access to memory provides more control and is useful for large datasets or high-performance caching systems like Ehcache.

### Hazelcast uses unsafe class

In **Hazelcast**, the **off-heap memory management** (referred to as **High-Density Memory Store** in Hazelcast Enterprise) uses Java’s `Unsafe` class for accessing and managing memory outside of the JVM's garbage-collected heap. This allows Hazelcast to avoid the overhead of garbage collection when managing large datasets, which improves performance by minimizing pauses caused by the garbage collector.

Instead of using JNI, Hazelcast implements its **own memory management system** based on pooled memory blocks. This is more efficient for applications that require fast access to large volumes of data, as it avoids interactions with the operating system for each memory allocation. The **memory is allocated in pages**, and smaller blocks of memory can be created and merged as needed using a **buddy allocation algorithm**. 

This model reduces memory fragmentation and makes off-heap memory highly efficient, especially for use cases like caching large datasets or storing distributed data structures. The **pluggable memory manager** allows Hazelcast to allocate memory to specific data structures like maps and caches without putting pressure on the JVM heap.

In summary, Hazelcast’s off-heap memory architecture is managed internally, leveraging **Java’s Unsafe class** for direct memory access and avoiding garbage collection-related issues. This is particularly useful for managing large, in-memory datasets efficiently in distributed environments.

