#### References

Programming in Scala - 1'st Edition online reading
http://www.artima.com/pins1ed/

https://www.scala-exercises.org/
http://allaboutscala.com/

http://docs.scala-lang.org/cheatsheets/
https://twitter.github.io/scala_school/index.html

http://www.codecommit.com/blog/scala/scala-for-java-refugees-part-1
Basic OOP
http://www.codecommit.com/blog/scala/scala-for-java-refugees-part-2
Methods and Statics
http://www.codecommit.com/blog/scala/scala-for-java-refugees-part-3 
Pattern Matching and Exceptions
http://www.codecommit.com/blog/scala/scala-for-java-refugees-part-4
Traits and Types
http://www.codecommit.com/blog/scala/scala-for-java-refugees-part-5
Getting Over Java
http://www.codecommit.com/blog/scala/scala-for-java-refugees-part-6
IBM: Java Develoer Guide to Scala
https://www.ibm.com/developerworks/views/java/libraryview.jsp?search_by=scala+neward

#### Types
Instead of declaring as int, in Scala it’s declared as Int.

> val decimal = 11235
> val long = 11235L
> val f = 0.0f


> val f = 0.0f
> val bookName = "Scala in \"Action\""
scala> val multiLine = """This is a
| multi line
| string"""

#### Val vs Var
A val is a single assignment variable, some- times called value. Once initialized a val can’t be changed or reassigned to some other value (similar to final variables in Java). On the other hand, var is reassignable;

#### Lazy evaluation of variables
scala> lazy val b = a + 1
The lazy keyword is allowed only with val; you can’t declare lazy var variables in Scala.


#### Scala uses = for type inference
```java
scala> def myFirstMethod() = { "exciting times ahead" }
myFirstMethod: ()java.lang.String
scala> myFirstMethod()
res6: java.lang.String = exciting times ahead
```
The significance of = after the method signature isn’t only to separate the signature from the method body but also to tell the Scala compiler to infer the return type of your function. If you omit that, Scala won’t infer your return type:
```java
scala> def myFirstMethod(){ "exciting times ahead" }
myFirstMethod: ()Unit
scala> myFirstMethod()
```
In this case when you invoke the function using the function name and (), you’ll get no result. In the REPL output, notice that the return type of your function is no longer java.lang.String; it’s Unit. Unit in Scala is like void in Java, and it means that the method doesn’t return anything.

Other valid ways of function calls :
```java
scala> def myFirstMethod = "exciting times ahead"
scala> myFirstMethod
scala> def max(a: Int, b: Int) = if(a > b) a else b
```

#### Generics Or Parameterized types
eg: create list of type
```java
scala> def toList[A](value:A) = List(value)
```

#### Adding Numbers in a list
```java
val evenNumbers :List[Int] = List(2,4,6,7,8)
val sum = evenNumbers.foldLeft(0) { (a :int, b :int) => a + b}
scala> val sum = evenNumbers.foldLeft(0) { (a, b ) => a + b}
scala> val sum = evenNumbers.foldLeft(0) { _ + _}
```

In Scala you can use underscores in various places, and their meaning is determined solely by the context and where they’re used.
. Function literals are a common idiom in Scala, and you’ll find occurrences of them in Scala libraries and codebases.
```java
val hasUpperCase = name.exists(_.isUpper)
```
In this case you’re invoking the given function literals for each character in the name string; when it finds an uppercase character, it will exit. 

---
Unit in scala is like Void

--

### Passing function as an argument
'''java
def breakable(op: => Unit) { ... }
'''
The special right arrow (=>) lets Scala know that the breakable function expects a function as a parameter. The right side of the => defines the return type of the function—in this case it’s Unit (similar to Java void)
For two argument functions:
'''java
def foldLeft(initialValue: Int, operator: (Int, Int) => Int)= { ... }
'''

--
### Printing elements of array
'''java
scala> array.foreach(println)
'''
### Mutable and Immutable data structures

The Array is a mutable data structure in scala

In Scala, List is immutable and makes functional-style programming easy.
```java
scala> val oldList = List(1, 2)
scala> val newList = 3 :: oldList
```
### Nil object
Scala provides a special object called Nil to represent an empty List, and you can use it to create new lists easily:
```java
scala> val myList = "This" :: "is" :: "immutable" :: Nil 
myList: List[java.lang.String] = List(This, is, immutable)
```
--
Eg: remove an element from list
```java
scala> val afterDelete = newList.filterNot(_ == 3)
```
--
scala does not support ternary operator
```java
scala> val configFile = if(useDefault) "custom.txt" else "default.txt"
```
---

#### For loop 
```java
val files = new java.io.File(".").listFiles
        for(file <- files) {
            val filename = file.getName
            if(fileName.endsWith(".scala")) println(file)
       }
OR
for{
    file <- files
    fileName = file.getName
    if(fileName.endsWith(".scala"))
} println(fileName)


OR
for(
    file <- files;
    fileName = file.getName;
    if(fileName.endsWith(".scala"))
) println(fileName)


```
for expressions may be defined with parenthesis or curly braces, but using curly braces means you don’t have to separate your filters with semicolons. Most of the time, you’ll prefer using curly braces when you have more than one filter, assignment, etc.

Reference on for loop

https://docs.scala-lang.org/tutorials/FAQ/yield.html

------
### switch case 
```java
def rangeMatcher(num:Int) = num match {
case within10 if within10 <= 10 => println("with in 0 to 10")
case within100 if within100 <= 100 => println("with in 11 to 100")
case beyond100 if beyond100 < Integer.MAX_VALUE => println("beyond 100")
}
```

And you no longer need to provide a break for each case because in Scala you can’t overflow into other case clauses 
(causing multiple matches) as in Java, and there’s no default statement. In Scala, default is replaced with case _ to match everything else.

```java
scala> List(1, 2, 3, 4) match {
        case f :: s :: rest => List(f, s)
        case _ => Nil
      }
res7: List[Int] = List(1, 2)
```
------------------------------

### Returns are discouraged
In fact, odd problems can occur if you use return statements in Scala because it changes the meaning of your program. For this reason, return statement usage is discouraged.

The return keyword is not “optional” or “inferred”; it changes the meaning of your program, and you should never use it.
http://tpolecat.github.io/2014/05/09/return.html

### Scala collection

- Basic : Seq, Map and Set
In seq we 
-- Indexed
-- Buffer
-- Linear

Where `indexed` is of type : array, range, vector

`Linear` is of type : List, Stack, Queue

`Buffer`  : ArrayBuffer and ListBuffer

For `mutable seq` where you want to keep changing elements, use the buffer type. Decide list or array based on whether accessing by index or traversing the elements


### When to use listBuffer
If there is list that is constantly changing then use list buffer and later convert to list. List by itself is immutable.
If however you are accessing a random element like x(1000) then better use ArrayBuffer which is indexed.

```java
t.append(123)
t += (6,6,6) 

// remove an element
t -= (6,6,6) 
// remove by index
t.remove(0)
t.remove(0,1)  
x.update(0,9)

// You can also use --= to delete multiple elements that are specified in another collection:

scala> val x = ListBuffer(1, 2, 3, 4, 5, 6, 7, 8, 9)
x: scala.collection.mutable.ListBuffer[Int] = ListBuffer(1, 2, 3, 4, 5, 6, 7, 8, 9)

scala> x --= Seq(1,2,3)
res0: x.type = ListBuffer(4, 5, 6, 7, 8, 9)
```


#### Q: What type should my API accept as input?
Answer: As general as possible. In most cases this will be Traversable <- Seq <- List.
Explanation: We want our API consumers to be able to call our code without needing them to convert types. If our function takes a Traversable, the caller can put almost any type of collection. This is usually sufficient if we just map(), fold(), head(), tail(), drop(), find(), filter() or groupBy(). In case you want to use length(), make it a Seq. If you need to efficiently prepend with ::, use a List.

#### Q: What type should my API return?

Answer: As specific as possible. Typically you want to return a List, Vector, Stack or Queue.
Explanation: This will not put any constraints on your API consumers but will allow them to eventually process returned data in optimal way and worry less about conversions.

### Vectors

vectors are faster than list for random access of elements . 

List is better when most of usage is around accessing the head or tail of the list

vectors are immutable. The update method gives a new vector that differs in only single element

vectors are implemented as tree
```java
// Begin with an empty vector.
val vector = scala.collection.immutable.Vector.empty

// Add new value at end of vector.
val vector2 = vector :+ 5

// Add 2 new values at end of vector.
val vector3 = vector2 :+ 10 :+ 20

// Add new value at start of vector.
val vector4 = 100 +: vector3

// Add elements from List of Ints to end of vector.
val v2 = v ++ List(10, 20, 30)

// Vector can contain elements of different types
Vector(1, "string") 
res71: Vector[Any] = Vector(1, sdf)

// Update element at index 1.
val changed = v2.updated(1, "bear")

// output of an expression running for n times
Vector.fill(5){
println("hello")
}

// Numbers in range
@ Vector.range(1,10) 
res73: Vector[Int] = Vector(1, 2, 3, 4, 5, 6, 7, 8, 9)
@ Vector.range(1,10,2) 
res74: Vector[Int] = Vector(1, 3, 5, 7, 9)


// calculate with the index of length 
Vector.tabulate(10){ _*5} 
res75: Vector[Int] = Vector(0, 5, 10, 15, 20, 25, 30, 35, 40, 45)
```

#### Q: Should I use List or Vector?
Answer: You most probably want a Vector, unless your algorithm can be expressed only using ::, head and tail, then use a List.
Scala Vector has a very effective iteration implementation and, comparing to List is faster in traversing linearly (which is weird?), so unless you are planning to do quite some appending, Vector is a better choice. Additionally, Lists don’t work well with parallel algorithms, it’s hard to break them down into pieces and put together in an efficient way.


#### Useful factory methods on collections

http://www.scala-lang.org/docu/files/collections-api/collections_45.html


#### Scala Operators
->, ||=, ++=, <=, _._, ::, and :+=.
http://stackoverflow.com/questions/7888944/what-do-all-of-scalas-symbolic-operators-mean


#### Lazy Val
Lazy val are evaluated once when they are used. They are only evaluated once. 
Sometimes its useful to have a lazy val than a function

```java
lazy  val x = { println(“do something”); “some value”}
```
The value of x will be evaluated only once when first used.

#### Partial functions
```java
val t :PartialFunction[Int,String] = { case i:Int  if i > 10 => i.toString}
```
This is partial since the function is defined only for few values of i 
``` java
@ t.isDefinedAt(2) 
res10: Boolean = false

t(1) will give an error, so instead to get a None use:

@ t.lift(2) 
res11: Option[String] = None
 
List(1,12) map t.lift 
res14: List[Option[String]] = List(None, Some("12"))

@ List(1,12) collect t 
res15: List[String] = List("12")

@ t.lift(21) map( _.toString) getOrElse "0" 
res30: String = "21"
@ t.lift(2) map( _.toString) getOrElse "0" 
res31: String = "0"
```

#### Chaining partial functions

The orElse method defined on the PartialFunction trait allows you to chain an arbitrary number of partial functions, creating a composite partial function. The first one, however, will only pass on to the next one if it isn’t defined for the given input.

val handler = fooHandler orElse barHandler orElse bazHandler

Where fooHandler, barHandler etc can come from different traits. So this allows composition 

#### Infix operations in scala
 1 + 5*2 is same as 1.+(5*2)

#### Apply
Every function in Scala can be treated as an object and it works the other way too - every object can be treated as a function, provided it has the apply method. Such objects can be used in the function notation:
```java
// we will be able to use this object as a function, as well as an object
object Foo {
  var y = 5
  def apply (x: Int) = x + y
}
Foo (1) // using Foo object in function notation 
```

This is useful for the factory pattern.

#### Package

package create a lexical namespace in which classes are declared. To help segregate code in such a way that it doesn't conflict with one another.

you can use import anywhere inside the client Scala file, not just at the top of the file and correspondingly, will have scoped relevance

By using the underscore , you effectively tell the Scala compiler that all of the members inside BigInteger should be brought into scope.


#### Trait Self Annotation

self : Base => 

Consider the examples below where both the traits are providing same functionalities. 

```java
class Base {
  def magic = "bibbity bobbity boo!!"
}

trait Extender extends Base {
  def myMethod = "I can "+magic
}

trait SelfTyper {
  self : Base => 
  
  def myMethod = "I can "+magic
}
```
But the two are completely different. 
Extender can be mixed in with any class and adds both the "magic" and "myMethod" to the class it is mixed with. 
SelfTyper can only be mixed in with a class that extends Base and SelfTyper only adds the method "myMethod" NOT "magic". 

Why is the "self annotations" useful? Because it allows several provides a way of declaring dependencies. One can think of the self annotation declaration as the phrase "I am useable with" or "I require a".


#### implicit
```java
> val i: Int = 3.5
<console>:5: error: type mismatch;
found   : Double(3.5)
required: Int
val i: Int = 3.5

scala> implicit def doubleToInt(x: Double) = x.toInt
doubleToInt: (Double)Int
  
scala> val i: Int = 3.5
i: Int = 3
// http://www.artima.com/pins1ed/implicit-conversions-and-parameters.html
```

#### Use Option not null
Option is an abstract class in Scala and defines two subclasses, Some and None.

Every now and then you encounter a situation where a method needs to return a value or nothing. But in the case of Scala, Option is the recommended way to go when you have a function return an instance of Some or otherwise return None.

You can use Option with pattern matching in Scala, and it also defines methods like map, filter, and flatMap so that you can easily use it in a for-comprehension.

Use get for getting the map values

```java
scala> val t = Map(("k1","v1") , ("k2","v2"))
scala> t.get("k1")
res4: Option[String] = Some(v1)
scala> t.get("k1").toString.length
res7: Int = 8
```

#### Convert scala list to java list

Scala list and java list are not compatible. When interfacing with java libarary you have to convert it from one form to another
```java
def toJavaList(scalaList: List[BasicNameValuePair]) = { 
java.util.Arrays.asList(scalaList.toArray:_*)					
} 
```
_* is required to get all all the values of the list

Use require inside class to enforce 

require(args.size >= 2, "at minimum you should specify action(post, get, delete, options) and url")

#### Convert tuple to map key and value
```java
scala> val t = (("k1","v1") , ("k2","v2"))
t: ((String, String), (String, String)) = ((k1,v1),(k2,v2))

scala> val t = Map(("k1","v1") , ("k2","v2"))
t: scala.collection.immutable.Map[String,String] = Map(k1 -> v1, k2 -> v2)

scala> t("k1")
res3: String = v1
```
----

#### Exists
// checks if string has upper case characters
name.exists(_.isUpper)
"asdf".contains("k")
// for list
(1 to 10).contains(5)

----

#### Type of constructors

`primary constructor` : the class body is primary constructor
```java
class Greeter(var message: String) {
    println("A greeter is being instantiated")    
    message = "I was asked to say " + message
    def SayHi() = println(message)
}
val greeter = new Greeter("Hello world!")
greeter.SayHi()
```
#### auxiliary constructor: 

```java
class Greeter(message: String, secondaryMessage: String) {
    def this(message: String) = this(message, "")    
    def SayHi() = println(message + secondaryMessage)
}

val greeter = new Greeter("Hello world!")
greeter.SayHi()
```


#### Slice
```java
//Slice :use c slice(from, to)
scala> Vector("hello", "world", "this", "is", "was") slice(2,5)
res38: scala.collection.immutable.Vector[String] = Vector(this, is, was)
```

#### Zip
```java
List(1,2,3) zip List("one","two","three")
res36: List[(Int, String)] = List((1,one), (2,two), (3,three))
```

#### dropWhile and takeWhile
Use dropWhile and takeWhile when you want to longest seqeunce from start when the predicate is true
```java
scala> Vector(1, 2, 3, 4, 5, 6) dropWhile { _ < 4}
res31: scala.collection.immutable.Vector[Int] = Vector(4, 5, 6)

scala> Vector(1, 2, 3, 4, 5, 6) takeWhile { _ < 4}
res32: scala.collection.immutable.Vector[Int] = Vector(1, 2, 3)
```

#### collect
collect is used with partial functions as
```java
List("hello","World",42) collect { case s:String => s}
// A instance of Seq, Set or Map is actually a partial function. So,
Seq(0,2,45) collect List("hello","World",42)
```

### predicate
A predicate is a anonymous function that takes one or more arguments and returns boolean
```java
filter(predicate)
eg: List(1,2,3,4).filter(p => p % 2 == 0)
or  List(1,2,3,4).filter(_ % 2 == 0)
```

#### Mutable Hashmap
For dictionary use the mutable HashMap
collection.mutable.Map[String, String]


#### flatMap
flatMap, applies the map operation then the flattens the list of list
eg: scala map treats the string as array of characters
```java
scala> "hello".map(x => "." + x)
res90: scala.collection.immutable.IndexedSeq[String] = Vector(.h, .e, .l, .l, .o)

scala> "hello".flatMap(x => "." + x)
res95: String = .h.e.l.l.o

scala> "hello".map(x => "." + x).flatten.mkString
res100: String = .h.e.l.l.o

scala> "hello".map(x => "." + x).toList.mkString
res94: String = .h.e.l.l.o
```
...

### for and foreach
```java
for(x <- t if x != "a") yield x
t.filter(x => x != "a").foreach(println)
```

#### Array To List

a.toList

####  Count (based on predicate)
Array(1,2,3,4,5,6).count(x =>  x > 3)

#### Exists (based on predicate)
Array(1,2,3,4,5,6).exists(x => x == 3)
...

#### Scala Different way of defining an anonymous function
```java
val t : Int => Boolean = (x :Int) => x > 5
val t1 = (x :Int) => { x > 5} :Boolean

val t2 = new ( (Int) => Boolean ) {
  def apply(x:Int) = x > 5
}
val t3 = new Function1[Int,Boolean] {
  def apply(x:Int) =  x > 5
}

val t4 = new {
  def apply(x :Int) : Boolean = x > 5
}
```
...

#### Scala functions as arguments
```java
val t : Int => Boolean = (x :Int) => x > 5
def someFunc(predicate:Int => Boolean, x :List[Int]){
  x.filter(t => predicate(t)).foreach(println)
}

someFunc(t,List(1,34, 5,34, 4,23))

val t5 = (x1: Int, x2:Int) => {x1 > x2} :Boolean
def someFunc2(predicate:(Int,Int) => Boolean, x :List[Tuple2[Int,Int]]){
  x.filter(t => predicate(t._1,t._2)).foreach(println)
}
someFunc2(t5,List((1,2),(5,4),(9,3)))
```

#### Functions vs Method
```java
//method
def m(i :Int) = i*i
// function
val p = (i :Int) => i*i
m(2)
p(2)
//m cannot be called without arguments
p 
// res2: Int => Int = <function1>
// method can be converted to function
val t = m _
```

#### Scala curry functions
def curryFunc(a:Int)(b:Int) = a + b
var t1 = curryFunc(5) _
t1(2)


#### Scala multiple parameters per list

def multipleParametersPerList(num : Int*) = num.sum
multipleParametersPerList(1,2,3) // will give 6


Prepending and appending to list
var x = 4 :: List(1,2) 
x = x :+ 0 

for and foreach
// for returns value (like select C#)
val t = for(i <- List(1,2,3)) yield i*2
val t = for(i <- List(1,3,5) if i < 5) yield i
// foreach returns Unit (void)
List(1,2,3).foreach(i => println(i*2))


#### Function Literals
class person(name :String) {def introduce = println(s" my name is $name")}
object person{def apply(name : String) = new person(name)}
var t = List[person](person("john"),person("lee"),person("kim"))
t foreach(_.introduce)
t foreach( x => x.introduce)
Instead of lambda, function literals can be used


Add to list
var t = List(1,2,3) 
t ::= 4 // will give Kist(4,1,2,3)
// compiler will turn ::= to > t = 4 :: t


Traits
Breaking up your application into small, focused traits is a powerful way to create reusable, scalable abstractions and “components.” Complex behaviors can be built up through declarative composition of traits. 
But also splitting objects into too many fine-grained traits can obscure the order of execution in your code!


Less Exception Handling
Scala encourages a coding style that lessens the need for exceptions and exception handling.


Map
Map by default are immutable . Import mutable map


Companion object
Companions must be defined together with class

Join a list of strings
> strings.mkstring


traits vs abstract class 
There are two main reasons to use an abstract class in Scala: 
You want to create a base class that requires constructor arguments. 
The code will be called from Java code.


For Loop 
for (breed <- dogBreeds) 
	println(breed)

var filteredBreeds = for (breed <- dogBreeds
	if breed.contains("Terrier")
	if !breed.startsWith("Yorkshire")
) yield breed



Pattern Matching

Simple 
for (bool <- bools) { 
	bool match {
		case true => println("heads")
		case false => println("tails")
		case _ => println("something other than heads or tails (yikes!)")
	} 
}
Variable Match
case i: Int => println("got an Integer: " + i)

Sequence Match
case List(_, 3, _, _) => println("Four elements, with the 2nd being '3'.")
case List(_*) => println("Any other list with 0 or more elements.") }

Tuples match and guards
case (thingOne, thingTwo) if thingOne == "Good" => println("A two-tuple starting with 'Good'.")

Case class match
case Person("Alice", 25) => println("Hi Alice!") 
case Person("Bob", 32) => println("Hi Bob!") 
case Person(name, age) =>println("Who are you, " + age + " year-old person named " + name + "?")

Regular Expression match
val date = """(\d\d\d\d)-(\d\d)-(\d\d)""".r
"2004-01-20" match {
  case date(year, month, day) => s"$year was a good year for PLs."
}

-------------------------------
Understanding pattern matching with Case

using the case class + traits we can achieve polymorphism as be using abstract class + derived classes 
eg : Check the shape, circle, triangle example for polymorphism at microsoft website
https://msdn.microsoft.com/en-us/library/ms173152.aspx

This could be done in scala as : 
trait  shape {
  def draw() :String
}

case class circle(x :Int,y :Int) extends shape{
  def draw(): String = {
    "Drawing a circle"
  }
}
case class Rectangle(x :Int,y :Int,height :Int,
                       width :Int ) extends shape{
  def draw(): String = {
    "Drawing a Rectange"
  }
}


var shapes = new circle(1,1) :: new Rectangle(1,1,2,2) ::Nil

def getShapes(element :shape) : String = element match{
  case i: circle => "Calling circle \n" + i.draw()
  case i: Rectangle => "Calling rectangle \n" + i.draw()
  case _ => "nothing"
}

var output = shapes.map(getShapes)
println(output.mkString)

The scala  code is more concise and readable.

Understanding companion objects 
Eg: 

class gen (age :Int) {
  var insideAge = age
  def say() = println(age)
}

object gen {
  var TESTVAL :Int = 10
  def apply(age :Int, inc :Int) = new gen(age + inc)
  def apply(age: Int) = new gen(age)
}

val g = new gen(34)
g.say()
g.insideAge				


val go1 = gen(111)
go1.say()
go1.insideAge
gen.TESTVAL = 111
gen.TESTVAL

val go = gen(22)
go.say()
go.insideAge
go1.say()
go1.insideAge
gen.TESTVAL = 222
gen.TESTVAL

val goo = gen(12,23)
goo.say()
goo.insideAge

------------------------------
Reading the function definition in scala

http://docs.scala-lang.org/tutorials/FAQ/breakout

definition of map:
def map[B, That](f : (A) => B)(implicit bf : CanBuildFrom[Repr, B, That]) : That

definition of breakout:
def breakOut[From, T, To](implicit b : CanBuildFrom[Nothing, T, To]) =
  new CanBuildFrom[From, T, To] {
    def apply(from: From) = b.apply() ; def apply() = b.apply()
  }

breakOut is parameterized, and that it returns an instance of CanBuildFrom. As it happens, the types From, T and To have already been inferred, because we know that map is expecting CanBuildFrom[List[String], (Int, String), Map[Int, String]]. 

Therefore:

From = List[String]
T = (Int, String)
To = Map[Int, String]

To conclude let’s examine the implicit received by breakOut itself. It is of type CanBuildFrom[Nothing,T,To]. We already know all these types, so we can determine that we need an implicit of type CanBuildFrom[Nothing,(Int,String),Map[Int,String]]. But is there such a definition?

Let’s look at CanBuildFrom’s definition:

trait CanBuildFrom[-From, -Elem, +To] 
extends AnyRef
So CanBuildFrom is contra-variant on its first type parameter. Because Nothing is a bottom class (ie, it is a subclass of everything), that means any class can be used in place of Nothing.

Since such a builder exists, Scala can use it to produce the desired output.

CanBuildFrom
http://docs.scala-lang.org/tutorials/FAQ/breakout
http://stackoverflow.com/questions/1722726/is-the-scala-2-8-collections-library-a-case-of-the-longest-suicide-note-in-hist


Function.tupled

Map(1 -> "one", 2 -> "two") map Function.tupled(_ -> _.length)
http://stackoverflow.com/questions/2354277/function-tupled-and-placeholder-syntax


co- and contravariant type parameters

From a bird’s eyes view, co- and contravariant type parameters can be seen as a tool to extend the reach of the type checker in generic classes. They offer additional type safety, which also means that this concept offers new possibilities for leveraging type hierarchies without having to give up on type safety. While developers have to fall back to using comments and conventions in other programming languages, since those languages aren’t able to guarantee type safety, you can achieve quite some mileage with the Scala type system.

https://blog.codecentric.de/en/2015/03/scala-type-system-parameterized-types-variances-part-1/


Parameterized Types and Variances
https://blog.codecentric.de/en/2015/04/the-scala-type-system-parameterized-types-and-variances-part-2/



Scala REPR

Repr is the underlying representation type of the collection. The main reason why Scala distinguishes between the collection type and the representation type is so that types which aren't part of Scala's collection framework, such as String, can still inherit all the collection methods. For proper collections, the representation type is usually the same as the type of the collection itself.CanBuildFrom[Repr, B, That] is a builder factory which will produce a builder that can create a Thatcollection with element type B from a collection with repr. type Repr.


Scala's type system is Turing-complete
http://stackoverflow.com/questions/4047512/the-type-system-in-scala-is-turing-complete-proof-example-benefits

What are all the uses of an underscore in Scala?

The ones I can think of are

Existential types
def foo(l: List[Option[_]]) = ...

Higher kinded type parameters
case class A[K[_],T](a: K[T])

Ignored variables
val _ = 5

Ignored parameters
List(1, 2, 3) foreach { _ => println("Hi") }

Wildcard patterns
Some(5) match { case Some(_) => println("Yes") }

Wildcard imports
import java.util._

Hiding imports
import java.util.{ArrayList => _, _}

Joining letters to punctuation
def bang_!(x: Int) = 5

Assignment operators
def foo_=(x: Int) { ... }

Placeholder syntax
List(1, 2, 3) map (_ + 2)

Partially applied functions
List(1, 2, 3) foreach println _
There may be others I have forgotten!


why foo(_) and foo _ are different ?

This example comes from 0__:

trait PlaceholderExample {
  def process[A](f: A => Unit)

  val set: Set[_ => Unit]

  set.foreach(process _) // Error 
  set.foreach(process(_)) // No Error
}
In the first case, process _ represents a method; Scala takes the polymorphic method and attempts to make it monomorphic by filling in the type parameter, but realizes that there is no type that can be filled in for A that will give the type (_ => Unit) => ? (Existential _ is not a type).

In the second case, process(_) is a lambda; when writing a lambda with no explicit argument type, Scala infers the type from the argument that foreach expects, and _ => Unit is a type (whereas just plain _ isn't), so it can be substituted and inferred.

This may well be the trickiest gotcha in Scala I have ever encountered.


Scala gothchas and puzzlers

JSON
https://www.playframework.com/documentation/2.3.9/ScalaJson

https://github.com/takezoe/solr-scala-client

http://blog.scalac.io/2016/01/14/scala-gotchas.html
http://scalapuzzlers.com/

			
		

