
### List
List is an interface. The following are implementations of List
- java.util.ArrayList
- java.util.LinkedList
- java.util.Vector
- java.util.Stack

```java
List listA = new ArrayList();
List listB = new LinkedList();
List<Integer> listC = new ArrayList<Integer>();

listA.add("element 1");
listA.add("element 2");
String element0 = listA.get(0);
String element1 = listA.get(1);

//access via Iterator
Iterator iterator = listA.iterator();
while(iterator.hasNext(){
  String element = (String) iterator.next();
}


//access via new for-loop
for(Object object : listA) {
    String element = (String) object;
}
```

### Map
Map is an interface. The implementations of map are
- java.util.HashMap
- java.util.Hashtable
- java.util.EnumMap
- java.util.IdentityHashMap
- java.util.LinkedHashMap
- java.util.Properties
- java.util.TreeMap
- java.util.WeakHashMap

Hashmap and Treemap are the most commonly used. 
- HashMap maps a key and a value. It does not guarantee any order of the elements stored internally in the map.
- TreeMap also maps a key and a value. Furthermore it guarantees the order in which keys or values are iterated - which is the sort order of the keys or values.

```java
Map mapA = new HashMap();
Map mapB = new TreeMap();
mapA.put("key1", "element 1");
String element1 = (String) mapA.get("key1");

// key iterator
Iterator iterator = mapA.keySet().iterator();

// value iterator
Iterator iterator = mapA.values();

Iterator iterator = mapA.keySet().iterator();
while(iterator.hasNext(){
  Object key   = iterator.next();
  Object value = mapA.get(key);
}

//access via new for-loop
for(Object key : mapA.keySet()) {
    Object value = mapA.get(key);
}

// remove
mapA.remove("key1")
```

#### When to use List, Set and Map 
1) If you do not want to have duplicate values in the database then Set should be your first choice as all of its classes do not allow duplicates.
2) If there is a need of frequent search operations based on the index values then List (ArrayList) is a better choice.
3) If there is a need of maintaining the insertion order then also the List is a preferred collection interface.
4) If the requirement is to have the key & value mappings in the database then Map is your best bet.

