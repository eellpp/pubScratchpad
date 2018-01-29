### Iterators

Iterator is an interface. Collections provide an iterator() method to return an iterator. 
- hasNext() => hasNext() method can be used for checking if there’s at least one element left to iterate over.
- next() => next() method can be used for stepping over the next element and obtaining it:
- remove

``` java
while (iter.hasNext()) {
    String next = iter.next();
    System.out.println(next);
  
    if( "TWO".equals(next)) {
        iter.remove();              
    }
}
```

### Iterator lazy operation
```java
List<Person> persons= ....
Iterable doeOnly= Iterables.filter(persons,DOE_AS_LAST_NAME_PREDICATE);
```
It means that the data is filtered as you request it - it doesn't go through your list immediately, and build up a new list of the filtered data. Instead, when you call iterator.next() (e.g. automatically in an enhanced for loop) the iterator will ask its upstream data source (your collection) for the next data item. It will then try to match this against the filter. If it matches it, it'll return that item. Otherwise, it'll ask for another item from the collection, keeping going until it either runs out of items or finds a match.

Then when you next ask for the next item, it'll keep going from where it left off.

In other words, it doesn't just mean "filtering happens only on the first call to doeOnly.next()" - it means "filtering happens on each call to iterator.next()" where iterator is the result of calling doeOnly.iterator().

#### Iterable vs Iterator

Iterable : A class that can be iterated over. That is, one that has a notion of "get me the first thing, now the next thing, and so on, until we run out."

Iterator : A class that manages iteration over an iterable. That is, it keeps track of where we are in the current iteration, and knows what the next element is and how to get it.

An implementation of Iterable is one that provides an Iterator of itself:

```java
public interface Iterable<T>
{
    Iterator<T> iterator();
}
An iterator is a simple way of allowing some to loop through a collection of data without assignment privileges (though with ability to remove).

public interface Iterator<E>
{
    boolean hasNext();
    E next();
    void remove();
}
```
An Iterable is a simple representation of a series of elements that can be iterated over. It does not have any iteration state such as a "current element". Instead, it has one method that produces an Iterator.

An Iterator is the object with iteration state. It lets you check if it has more elements using hasNext() and move to the next element (if any) using next().

Typically, an Iterable should be able to produce any number of valid Iterators.
