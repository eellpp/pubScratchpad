### primitive data types

- boolean
- character
- byte
- short
- integer
- long
- float
- double

saved in stack/heap in the memory which is managed memory on the other hand object data type or reference data type are allocated objected which is managed by GC

### Lambda Function Types
Use Supplier if it takes nothing, but returns something.

Use Consumer if it takes something, but returns nothing.

Use Callable if it returns a result and might throw (most akin to Thunk in general CS terms).

Use Runnable if it does neither and cannot throw.

- Supplier       ()    -> x
- Consumer       x     -> ()
- BiConsumer     x, y  -> ()
- Callable       ()    -> x throws ex
- Runnable       ()    -> ()
- Function       x     -> y
- BiFunction     x,y   -> z
- Predicate      x     -> boolean
- UnaryOperator  x1    -> x2
- BinaryOperator x1,x2 -> x3

### Stack Vs Heap

When a method is called, certain data is placed on the stack. When the method finishes, data is removed from the stack. At other points in a program's execution, data is added to the stack, or removed from it.

Therefore, if you have a variable which is intended to outlive the execution of the method that created it, it needs to be on the heap. This applies both to any objects that you create, and any primitives that are stored within those objects.

However, if a variable is intended to go out of scope shortly after its creation - say, at the end of the method in which it's created, or even earlier, then it's appropriate for that variable to be created on the stack. Local variables and method arguments fit this criterion; if they are primitives, the actual value will be on the stack, and if they are objects, a reference to the object (but not the object itself) will be on the stack.

### Memory consumption

byte, boolean	1 byte
short, char	2 bytes
int, float	4 bytes
long, double	8 bytes
Byte, Boolean	16 bytes
Short, Character	16 bytes
Integer, Float	16 bytes
Long, Double	24 bytes
Arrays consume 12 bytes plus their length multiplied by their element size

### Memory used by String
String is essentially and array of char with the index etc

(bytes) = 8 * (int) ((((no chars) * 2) + 45) / 8)

An empty string will consume 40 bytes. A 19 char string will consume 80 bytes

https://stackoverflow.com/a/31207050

### Optimization tips
- Prefer primitive types to their Object wrappers. eg: byte[] instead of String
- Try to minimize number of Objects you have


### Example of optimization
Here is an example. Suppose you have to create a map from int to 20 character long strings. The size of this map is equal to one million and all mappings are static and predefined (saved in some dictionary, for example).

The first approach is to use a Map<Integer, String> from the standard JDK. Let’s roughly estimate the memory consumption of this structure. Each Integer occupies 16 bytes plus 4 bytes for an Integer reference from a map. Each 20 character long String occupies 36 + 20*2 = 76 bytes (see String description above), which are aligned to 80 bytes. Plus 4 bytes for a reference. The total memory consumption will be roughly (16 + 4 + 80 + 4) * 1M = 104M.

The better approach will be replacing String with a byte[] in UTF-8 encoding as described in String packing part 1: converting characters to bytes article. Our map will be Map<Integer, byte[]>. Assume that all string characters belong to ASCII set (0-127), which is true in most of English-speaking countries. A byte[20] occupies 12 (header) + 20*1 = 32 bytes, which conveniently fit into 8 bytes alignment. The whole map will now occupy (16 + 4 + 32 + 4) * 1M = 56M, which is 2 times less than the previous example.

Now let’s use Trove TIntObjectMap<byte[]>. It stores keys as normal int[] compared to wrapper types in JDK collections. Each key will now occupy exactly 4 bytes. The total memory consumption will go down to (4 + 32 + 4) * 1M = 40M.

The final structure will be more complicated. All String values will be stored in the single byte[] one after another with (byte)0 as a separator (we still assume we have a text-based ASCII strings). The whole byte[] will occupy (20 + 1) * 1M = 21M. Our map will store an offset of the string in the large byte[] instead of the string itself. We will use Trove TIntIntMap for this purpose. It will consume (4 + 4) * 1M = 8M. The total memory consumption in this example will be 8M + 21M = 29M. By the way, this is the first example relying on the immutability of this dataset.

Can we achieve the better result? Yes, we can, but at a cost of CPU consumption. The obvious ‘optimization’ is to sort the whole dataset by keys before storing values into a large byte[]. Now we may store the keys in the int[] and use a binary search to look for a key. If a key is found, its index multiplied by 21 (remember, all strings have the same length) will give us the offset of a value in the byte[]. This structure occupies ‘only’ 21M + 4M (for int[]) = 25M at a price of O(log N) lookups compared to O(1) lookups in case of a hash map.

Is this the best we can do? No! We have forgotten that all values are 20 characters long, so we don’t actually need the separators in the byte[]. It means that we can store our ‘map’ using 24M memory if we agree on O( log N ) lookups. No overhead at all compared to theoretical data size and nearly 4.5 times less than required by the original solution ( Map<Integer, String> )! Who told you that Java programs are memory hungry?

http://java-performance.info/overview-of-memory-saving-techniques-java/

### Arrays
```java
int[] arr = new int[10]
int[] arr2 = {1,2,3}
int[] arr3 = new int[]{1,2,3}
```

#### java.util.Arrays contains the useful method
- asList

 List<int> list = Arrays.asList(1, 2, 3);

ArrayList internally is an array of objects of type with ability to grow. 
An ArrayList extends AbstractList and implements four interfaces viz. List<E>, RandomAccess, Cloneable, java.io.Serializable.
And it stores elements in an Object[] array as: private transient Object[] elementData;
If you say: ArrayList arr=new ArrayList(); then by default it creates an ArrayList of size 10.
There is a method private void grow(int minCapacity) which resizes the ArrayList

- sort
- equals
- binarySearch
  
#### ArrayList vs LinkedList
LinkedList<E> allows for constant-time insertions or removals using iterators, but only sequential access of elements. 

ArrayList<E>, on the other hand, allow fast random read access, so you can grab any element in constant time. But adding or removing from anywhere but the end requires shifting all the latter elements over, either to make an opening or fill the gap. Also, if you add more elements than the capacity of the underlying array, a new array (1.5 times the size) is allocated, and the old array is copied to the new one, so adding to an ArrayList is O(n) in the worst case but constant on average.
 
 - The main benefits of using a LinkedList arise when you re-use existing iterators to insert and remove elements. These operations
 can then be done in O(1) by changing the list locally only. In an array list, the remainder of the array needs to be moved (i.e. copied). 

- Another benefit of using a LinkedList arise when you add or remove from the head of the list, since those operations are O(1), while they are O(n) for ArrayList
